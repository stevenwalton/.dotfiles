'''
Author: Steven Walton
Messy script to clean out wandb jobs
Use as a template and maybe I'll move to a meaningful script.
I needed this for clearing off accidental runs that saved way more images than
needed
'''
from rich import print
import wandb
from joblib import Parallel, delayed

team="sjwaltonteam"
project="StyleNAT"
api = wandb.Api(timeout=30)
runs = api.runs(path=f"{team}/{project}",
                order="+created_at",
                )
def deleteme(file):
    fname = file.name
    #print(f"{fname=}")
    if fname[-4:] != ".png": return
    n = fname.split("_")[1]
    try:
        if int(n) % 10000 > 0:
            if int(n) % 1000 == 0:
                print(f"\tDeleting {fname}")
            file.delete()
    except:
        print(f"[bold red]ERROR:[/bold red] Couldn't process {fname}")

for run in runs:
    files = run.files()
    print(f"Run {run.name} ({len(files)} files)")
    if "best" in run.name: continue
    Parallel(n_jobs=40,
             #verbose=151,
             require="sharedmem",
             )(
        delayed(deleteme) (file) for file in files)
    #for file in run.files():
    #    fname = file.name
    #    if fname[-4:] != ".png": continue
    #    n = fname.split("_")[1]
    #    if int(n) % 10000 > 0:
    #        if int(n) % 1000 == 0:
    #            print(f"\tDeleting {fname=}")
    #        file.delete()
