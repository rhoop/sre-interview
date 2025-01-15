"""
starts a worker process
"""
import signal
import time

from shared import consume_cpu, consume_memory, handle_signal, is_exiting


def main():
    """
    starts a no-op worker that consumes resources
    """
    while True:
        if is_exiting():
            print("exiting cleanly")
            break

        print("consuming cpu")
        consume_cpu()
        print("consuming memory")
        consume_memory()
        print("sleeping for 10 seconds")
        time.sleep(10)


if __name__ == "__main__":
    signal.signal(signal.SIGTERM, handle_signal)

    main()
