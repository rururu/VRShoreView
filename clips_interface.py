import clips

env = clips.Environment()

def clips_eval(command):
    try:
        return env.eval(command)
    except clips.CLIPSError as err:
        return "Err: CLIPS error: {0}".format(err) + ", command: " + command
    except OSError as err:
        return "Err: OS error: {0}".format(err) + ", command: " + command
    except BaseException as err:
        return "Err: BaseException: {0}".format(err) + ", type: {0}".format(type(err)) + ", command: " + command
    else:
        return "Err: Unexpected error!, command: " + command

def clips_load(path):
    return env.load(path)

def clips_load_list(lst):
    print("Loading..")
    for p in lst:
        r = env.eval('(load "'+p+'")')
        print(p+' : '+str(r))

def clips_batch_star(path):
    return env.batch_star(path)
    
def clips_clear():
    return env.clear()

def clips_reset():
    return env.reset()

def clips_run():
    return env.eval("(run)")

def clips_watch(x):
    return env.eval("(watch "+x+")")

def clips_assert(s):
    env.assert_string(s)

def clips_symbol(s):
    return clips.Symbol(s)

def clips_environment():
    global env
    return env

