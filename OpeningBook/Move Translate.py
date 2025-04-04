import chess


liste = []

def func(moves):
    board = chess.Board()
    string = ""
    for move in moves:
        if (move=="1/2-1/2"):
            print(moves)
        if (move=="1-0"):
            print(moves)
        if (move=="0-1"):
            print(moves)
        uci_text = board.push_san(move).uci()
        if (uci_text[-1]=="q" or uci_text[-1]=="r" or uci_text[-1]=="b" or uci_text[-1]=="n"):
            uci_text = uci_text[0:-1]+uci_text[-1].upper()
        string += uci_text+" "
    return string[0:-1]

file = open("Open.txt","r")
file = file.readlines()

for i in file:
    liste.append(func(i.split(" ")[0:-1]))

file = open("Pos.txt","w")
for i in liste:
    file.write(i+"\n")
file.close()
