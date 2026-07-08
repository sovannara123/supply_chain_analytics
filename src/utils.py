import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from pathlib import Path


VISUALS_DIR = Path(__file__).resolve().parent.parent / 'visuals'


def setup_plotting():
    VISUALS_DIR.mkdir(exist_ok=True)
    sns.set_theme(style='whitegrid', palette='viridis')
    plt.rcParams['figure.figsize'] = (11, 6)
    plt.rcParams['axes.titlesize'] = 14
    plt.rcParams['axes.titleweight'] = 'bold'


def save_fig(name):
    plt.tight_layout()
    plt.savefig(VISUALS_DIR / f'{name}.png', dpi=150, bbox_inches='tight')
