#pragma once

#include <fcntl.h>
#include <functional>
#include <iostream>
#include <signal.h>
#include <sstream>
#include <sys/stat.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

struct System {
  static void profile(const std::string &name, std::function<void()> body) {
    std::string filename =
        name.find(".csv") == std::string::npos ? (name + ".csv") : name;

    // Launch profiler
    pid_t pid;
    std::stringstream s;
    std::string flags =
        "branch-instructions,branch-misses,cache-references,cache-misses,cpu-"
        "cycles,context-switches,page-faults,task-clock,L1-dcache-load-misses,"
        "L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-"
        "misses,LLC-loads,LLC-store-misses,LLC-stores,duration_time";
    s << getpid();
    pid = fork();
    if (pid == 0) {
      auto fd = open("/dev/null", O_RDWR);
      dup2(fd, 1);
      dup2(fd, 2);
      exit(execl("/usr/bin/perf", "sudo perf", "stat", "-o", filename.c_str(),
                 "-x,", "-e", flags.c_str(), "-p", s.str().c_str(), nullptr));
    }

    // Run body
    body();

    // Kill profiler
    kill(pid, SIGINT);
    waitpid(pid, nullptr, 0);
  }

  static void profile(std::function<void()> body) {
    profile("perf.data", body);
  }
};

// std::string flags =
//     "branch-instructions,branch-misses,cache-references,cache-misses,cpu-"
//     "cycles,context-switches,page-faults,task-clock,L1-dcache-load-misses,"
//     "L1-dcache-loads,L1-dcache-stores,L1-icache-load-misses,LLC-load-"
//     "misses,LLC-loads,LLC-store-misses,LLC-stores,duration_time";
// exit(execl("/usr/bin/perf", "perf", "stat", "-r", "1", "-x", "-o",
//            filename.c_str(), "-e", flags.c_str(), "-p",
//            s.str().c_str(), nullptr));