import os
import subprocess

flags = [
    '-Wall',
    '-Wextra',
    '-Werror',
    '-std=c++11',
    '-x', 'c++',
]

pkg_config_modules = [
]


def pkg_config_flags():
    flags = []

    for m in pkg_config_modules:
        proc = subprocess.Popen('pkg-config --cflags {}'.format(m),
                                shell=True, stdout=subprocess.PIPE)
        proc.wait()
        flags += proc.stdout.read().split(' ')

    return flags


def flag_path_to_absolute(flags, working_directory):
    if not working_directory:
        return list(flags)

    new_flags = []
    make_next_absolute = False
    path_flags = ['-isystem', '-I', '-iquote', '--sysroot=']
    for flag in flags:
        new_flag = flag

        if make_next_absolute:
            make_next_absolute = False
            if not flag.startswith('/'):
                new_flag = os.path.join(working_directory, flag)

        for path_flag in path_flags:
            if flag == path_flag:
                make_next_absolute = True
                break

            if flag.startswith(path_flag):
                path = flag[len(path_flag):]
                new_flag = path_flag + os.path.join(working_directory, path)
                break

        if new_flag:
            new_flags.append(new_flag)
    return new_flags


def FlagsForFile(filename, **kwargs):
    final_flags = flag_path_to_absolute(
        flags + pkg_config_flags(), os.path.dirname(os.path.abspath(__file__)))

    return {
        'flags': final_flags,
        'do_cache': True
    }
