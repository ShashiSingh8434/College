import socket

# Create socket
client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Server address
SERVER_HOST = '127.0.0.1'
SERVER_PORT = 5000

# Connect to server
client_socket.connect((SERVER_HOST, SERVER_PORT))

# Get client's IP address
client_ip = socket.gethostbyname(socket.gethostname())

print("Client IP Address:", client_ip)

# Send IP address to server
client_socket.send(client_ip.encode())

print("IP address sent to server successfully.")

# Close connection
client_socket.close()