# 🏡 Airbnb Price Tier Classifier

This project builds a machine learning classifier to predict Airbnb listing price tiers (`Low`, `Mid`, `High`) based on listing attributes using data from [Inside Airbnb](http://insideairbnb.com/get-the-data.html).

---

## 📦 Project Structure




---

## 🧠 Model

- **Algorithm**: LightGBM Classifier (best performer vs. XGBoost, RF, HGB)
- **Target Variable**: `price_bin` (Low, Mid, High tiers)
- **Features Used**:
  - Location: `latitude`, `longitude`, `distance_to_region_center`
  - Host: `host_experience_level`, `calculated_host_listings_count`
  - Reviews: `number_of_reviews`, `reviews_per_month`, `price_per_review`
  - Others: `minimum_nights`, `availability_365`, `room_type`

---

## 📊 Results

- **Accuracy**: ~97% on validation set
- **Confusion Matrix** and **SHAP summary plot** included in notebook
- `price_per_review` and `number_of_reviews` are most impactful features

---

## 🔍 SHAP Explainability

SHAP plots are generated to:
- Visualize global feature importance
- Explain individual predictions
- Reveal interaction between latitude/longitude and pricing class

> See `shap_explanations/` folder for saved figures.

---

## 🚀 Quickstart

### 1. Install dependencies
```bash
pip install -r requirements.txt
```

### 2. Run model notebook
Open model_training.ipynb and execute all cells.

### 3. (Optional) Launch Streamlit app
```bash
streamlit run streamlit_app.py
```
### 🛠 Tech Stack
- Python 3.10
- scikit-learn
- LightGBM, XGBoost
- SHAP
- Pandas, Matplotlib
- Streamlit (optional)

### 📝 License
MIT License. See LICENSE file.

### 📬 Contact
Created by Leeza Sergeeva – feel free to reach out via GitHub or email.

### ✅ `requirements.txt`

```txt
pandas==2.0.3
numpy==1.24.4
scikit-learn==1.3.0
lightgbm==4.1.0
xgboost==1.7.6
shap==0.43.0
matplotlib==3.7.2
streamlit==1.27.2  # optional
joblib==1.3.2
```
