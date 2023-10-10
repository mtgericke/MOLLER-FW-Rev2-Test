cmake_minimum_required(VERSION 3.10)

project(moller)

include_directories(
    src/
    src/external
    src/lib/discovery
)

add_executable(moller
    src/moller.c
    src/task_cmd.c
    src/task_discovery.c
    src/task_dma.c
    src/task_sensor.c
    src/task_tinode.c
    src/lib/discovery/discovery.c
    src/lib/discovery/discovery_udp_linux.c
)

target_link_libraries(moller
    zmq
    pthread
    lz4
    gpiod
)
