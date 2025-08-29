from __future__ import annotations
import json, time, random
from pathlib import Path
import numpy as np
from sklearn import datasets, tree, model_selection, metrics
from joblib import dump

CFG_PATH = Path(__file__).resolve().parents[2] / "configs" / "config.yaml"

def load_cfg():
    import yaml
    with open(CFG_PATH, "r", encoding="utf-8") as f:
        return yaml.safe_load(f)

def set_seed(s: int):
    random.seed(s); np.random.seed(s)

def main():
    cfg = load_cfg()
    set_seed(cfg["seed"])
    X, y = datasets.load_iris(return_X_y=True)
    Xtr, Xte, ytr, yte = model_selection.train_test_split(
        X, y, test_size=cfg["test_size"], random_state=cfg["seed"]
    )
    clf = tree.DecisionTreeClassifier(max_depth=cfg["max_depth"], random_state=cfg["seed"])
    clf.fit(Xtr, ytr)
    yhat = clf.predict(Xte)
    acc = metrics.accuracy_score(yte, yhat)
    print(f"accuracy={acc:.4f}")

    out = Path("runs") / time.strftime("%Y%m%d_%H%M%S")
    out.mkdir(parents=True, exist_ok=True)
    dump(clf, out / "model.joblib")
    with open(out / "metrics.json", "w") as f:
        json.dump({"accuracy": float(acc)}, f, indent=2)
    print("artefactos en:", out)

if __name__ == "__main__":
    main()
