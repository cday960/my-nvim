#!/usr/bin/env python3
"""
Generate a cross-tabulation heatmap from a CSV file.

Usage:
    dbout_heatmap.py <csv_path> <row_col> <col_col> <output_png> [title]
"""

import sys
import pandas as pd
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np


def main():
    if len(sys.argv) < 5:
        print("Usage: dbout_heatmap.py <csv_path> <row_col> <col_col> <output_png> [title]")
        sys.exit(1)

    csv_path = sys.argv[1]
    row_col = sys.argv[2]
    col_col = sys.argv[3]
    png_path = sys.argv[4]
    title = sys.argv[5] if len(sys.argv) > 5 else f"{row_col} vs {col_col}"

    df = pd.read_csv(csv_path)

    df.columns = df.columns.str.strip()
    row_col = row_col.strip()
    col_col = col_col.strip()

    if row_col not in df.columns:
        print(f"Column '{row_col}' not found. Available: {list(df.columns)}")
        sys.exit(1)
    if col_col not in df.columns:
        print(f"Column '{col_col}' not found. Available: {list(df.columns)}")
        sys.exit(1)

    df[row_col] = df[row_col].astype(str).str.strip()
    df[col_col] = df[col_col].astype(str).str.strip()

    ct = pd.crosstab(df[row_col], df[col_col])

    ct = ct.loc[ct.sum(axis=1).sort_values(ascending=False).index]
    ct = ct[ct.sum(axis=0).sort_values(ascending=False).index]

    n_rows, n_cols = ct.shape
    fig_w = max(8, n_cols * 1.2 + 3)
    fig_h = max(6, n_rows * 0.6 + 2)

    fig, ax = plt.subplots(figsize=(fig_w, fig_h))

    fig.patch.set_facecolor("#1a1b26")
    ax.set_facecolor("#1a1b26")

    cmap = matplotlib.colors.LinearSegmentedColormap.from_list(
        "dbout", ["#1a1b26", "#1e3a2f", "#2d6a4f", "#40916c", "#74c69d"]
    )

    im = ax.imshow(ct.values, cmap=cmap, aspect="auto")

    ax.set_xticks(np.arange(n_cols))
    ax.set_yticks(np.arange(n_rows))
    ax.set_xticklabels(ct.columns, rotation=45, ha="right", fontsize=9, color="#a9b1d6")
    ax.set_yticklabels(ct.index, fontsize=9, color="#a9b1d6")

    thresh = ct.values.max() / 2
    for i in range(n_rows):
        for j in range(n_cols):
            val = ct.values[i, j]
            if val > 0:
                color = "#1a1b26" if val > thresh else "#a9b1d6"
                ax.text(j, i, str(val), ha="center", va="center",
                        fontsize=8, color=color, fontweight="bold")

    ax.set_xlabel(col_col, fontsize=11, color="#c0caf5", labelpad=10)
    ax.set_ylabel(row_col, fontsize=11, color="#c0caf5", labelpad=10)
    ax.set_title(title, fontsize=13, color="#c0caf5", pad=15, fontweight="bold")

    cbar = fig.colorbar(im, ax=ax, shrink=0.8)
    cbar.ax.yaxis.set_tick_params(color="#a9b1d6")
    cbar.outline.set_edgecolor("#565f89")
    plt.setp(cbar.ax.yaxis.get_ticklabels(), color="#a9b1d6")

    ax.set_xticks(np.arange(-0.5, n_cols, 1), minor=True)
    ax.set_yticks(np.arange(-0.5, n_rows, 1), minor=True)
    ax.grid(which="minor", color="#565f89", linewidth=0.5)
    ax.tick_params(which="minor", size=0)

    for spine in ax.spines.values():
        spine.set_edgecolor("#565f89")

    plt.tight_layout()
    plt.savefig(png_path, dpi=150, facecolor=fig.get_facecolor())
    plt.close()
    print(f"Saved: {png_path}")


if __name__ == "__main__":
    main()
