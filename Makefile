TARGET_DIR = test

all:
	(cd $(TARGET_DIR) ; make;)
clean:
	(cd $(TARGET_DIR) ; make clean)
