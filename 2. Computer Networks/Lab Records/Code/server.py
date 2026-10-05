import socket

# Create socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Server IP and port
HOST = '0.0.0.0'
PORT = 5000

# Bind socket to address
server_socket.bind((HOST, PORT))

# Listen for client connection
server_socket.listen(1)

print("Server is waiting for a client...")

# Accept connection
client_socket, client_address = server_socket.accept()

print("Client connected!")
print("Client IP Address:", client_address[0])

# Receive IP address sent by client
client_ip = client_socket.recv(1024).decode()

print("IP Address received from client:", client_ip)

# Close connection
client_socket.close()
server_socket.close()