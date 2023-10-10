APP = moller

# Add any other object files to this list below
APP_OBJS = moller.o adoption/adoption_udp_linux.o adoption/adoption.o

LDLIBS = -lzmq -lpthread

INC_DIR = ./adoption

all: build

build: $(APP)

$(APP): $(APP_OBJS)
	$(CXX) -I$(INC_DIR) -o $@ $(APP_OBJS) $(LDFLAGS) $(LDLIBS)

clean:
	rm -f $(APP) *.o
