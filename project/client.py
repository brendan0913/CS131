# Referenced TA Repo client starter code
import asyncio, sys
import argparse

server_names = {'Riley':12510, 'Jaquez':12511, 'Juzang':12512, 'Campbell':12513, 'Bernard':12514}
localhost = '127.0.0.1'

class Client:
    def __init__(self, port=7788):
        self.port = port

    async def tcp_echo_client(self, message):
        reader, writer = await asyncio.open_connection(localhost, self.port)
        print(f'Client sent: {message}')
        writer.write(message.encode())

        data = await reader.read(1000000)
        print(f'Client received: {data.decode()}')

        print('Closed the socket')
        writer.close()

parser = argparse.ArgumentParser('parser')
parser.add_argument('server_name', type=str)
args = parser.parse_args()
if not args.server_name in server_names:
    print(f'Invalid server name {args.server_name}')
    exit()
client = Client(server_names[args.server_name])
while True:
    message = input('Input the next message: ')
    message += '\n'
    asyncio.run(client.tcp_echo_client(message))