import sys, argparse
import asyncio, aiohttp, json
import time
import logging

NAMES = {'Riley':12510, 'Jaquez':12511, 'Juzang':12512, 'Campbell':12513, 'Bernard':12514}
CONNECTIONS = {
    'Riley': ['Jaquez', 'Juzang'],
    'Jaquez': ['Riley', 'Bernard'],
    'Juzang': ['Riley', 'Campbell', 'Bernard'],
    'Campbell': ['Juzang', 'Bernard'],
    'Bernard': ['Jaquez', 'Juzang', 'Campbell']
}
HOSTNAME = '127.0.0.1'
KEY = 'AIzaSyDZaGdbRn7KV0ad2c7r4gOQDrrLbML3qKY'

def print_and_log(m):
    print(m)
    logging.info(m)

parser = argparse.ArgumentParser('parser')
parser.add_argument('name', type=str)
args = parser.parse_args()
server_name = args.name
if server_name not in NAMES:
    print(f'Invalid server name: {server_name}')
    exit()
port = NAMES[server_name]
client_time_dict = {}   # dict for timestamps of messages
client_msg_dict = {}    # dict for AT messages
logging.basicConfig(filename=f'{server_name}.log', encoding='utf-8', format='%(levelname)s: %(message)s', filemode='w+', level=logging.INFO)    
print_and_log(f'Initialized log file and opened {server_name} server')

async def flood(msg):
    for connection in CONNECTIONS[server_name]:
        try: 
            reader, writer = await asyncio.open_connection(HOSTNAME, NAMES[connection])
            writer.write(msg.encode())
            print_and_log(f'{server_name} wrote to {connection}: {msg}')
            await writer.drain()
            writer.close()
            await writer.wait_closed()
            print_and_log(f'Completed propagation to {connection}')
        except:
            print_and_log(f'Failed connecting to server {connection}')

# Refernced TA Repo for json hint
async def get_places(location, radius, info_bound):
    async with aiohttp.ClientSession() as session:
        url = f'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location={get_location(location)}&radius={radius}&key={KEY}'
        async with session.get(url) as response:
            places = await response.json(loads=json.loads)
        num_places = len(places['results'])
        if num_places == 1:
            print_and_log(f'Retrieved {num_places} place from API')
        else:
            print_and_log(f'Retrieved {num_places} places from API')
        bound = int(info_bound)
        if num_places > bound:
            places['results'] = places['results'][:bound]
        return json.dumps(places, sort_keys=True, indent=4)

# Referenced TA Repo for parsing messages hint
async def process_input(reader, writer):
    while not reader.at_eof():
        line = await reader.readline()
        msg = line.decode()
        if msg == '':
            continue
        print_and_log(f'{server_name} received: {msg}')
        msg_split = msg.strip().split()
        if len(msg_split) == 0:
            break
        response = None
        if ((msg_split[0] == 'IAMAT' or msg_split[0] == 'WHATSAT') and len(msg_split) != 4) or (msg_split[0] == 'AT' and len(msg_split) != 6):
            print_and_log(f'Invalid number of args for {msg_split[0]}: {len(msg_split)}')
            response = f'? {msg}'
        elif msg_split[0] == 'IAMAT': # IAMAT client latitude_longitude(ISO6709) time(POSIX)
            client = msg_split[1]
            lat_long = msg_split[2]
            time_sent = msg_split[3]
            lat_long_split = lat_long.replace('-','|').replace('+','|').split('|')
            pair = []
            for l in lat_long_split:
                if not l == '':
                    pair.append(l)
            if len(pair) != 2 or not is_num(pair[0]) or not is_num(pair[1]) or not is_num(time_sent):
                response = f'? {msg}'
            else:
                time_float = float(time_sent)
                client_time_dict[client] = time_float
                elapsed_time = time.time() - time_float
                if elapsed_time > 0:
                    str_time = f'+{str(elapsed_time)}'
                else:
                    str_time = str(elapsed_time)
                response = f'AT {server_name} {str_time} {client} {lat_long} {time_sent}'
                client_msg_dict[client] = response
                await flood(response)
        elif msg_split[0] == 'WHATSAT': # WHATSAT client radius(<=50) info_bound(<=20)
            client = msg_split[1]
            radius = msg_split[2]
            info_bound = msg_split[3]
            if client not in client_time_dict:
                print_and_log(f'Unknown location for client: {client}')
                response = f'? {msg}'
            elif not is_num(radius) or not is_num(info_bound) or int(radius) < 0 or int(radius) > 50 or int(info_bound) < 0 or int(info_bound) > 20:
                response = f'? {msg}'
            else:
                at_msg = client_msg_dict[client]
                lat_long = at_msg.split()[4]
                places = (await get_places(lat_long, radius, info_bound)).rstrip('\n')
                response = f'{at_msg}\n{places}\n\n'
        elif msg_split[0] == 'AT':   # AT server time_difference client location time
            server = msg_split[1]
            elapsed_time = msg_split[2]
            client = msg_split[3]
            lat_long = msg_split[4]
            time_float = float(msg_split[5])
            if client in client_msg_dict and time_float <= client_time_dict[client]:
                print_and_log(f'Already received info about {client} prior to this message')
            else:
                client_msg_dict[client] = msg
                client_time_dict[client] = time_float
                print_and_log(f'Updated and propagated new information about {client}')
                await flood(msg)
        else:
            response = f'? {msg}'
        if response:
            writer.write(response.encode())
            print_and_log(f'Sent response to client: {response}')
    print_and_log("Serviced current message, awaiting next message")
    writer.close()

async def run_server():
    print_and_log(f'Starting {server_name} server')
    server = await asyncio.start_server(process_input, HOSTNAME, port)
    async with server:
        await server.serve_forever()

def is_num(s):
    try:
        float(s)
        return True
    except:
        return False

def get_location(c):
    plus = c.rfind('+')
    minus = c.rfind('-')
    comma = max(plus, minus)
    return f'{c[:comma]},{c[comma:]}'

try:
    asyncio.run(run_server())
except KeyboardInterrupt:
    print_and_log(f'Ending {server_name} session')
