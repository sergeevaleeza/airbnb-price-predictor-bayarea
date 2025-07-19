import streamlit as st
import pandas as pd
import numpy as np
import shap
import joblib
import lightgbm as lgb
import matplotlib.pyplot as plt

# Define features (used for validation)
features = [
    'room_type',
    'latitude',
    'longitude',
    'minimum_nights',
    'number_of_reviews',
    'reviews_per_month',
    'calculated_host_listings_count',
    'availability_365',
    'number_of_reviews_ltm',
    'region_encoded',
    'distance_to_region_center',
    'host_experience_level',
    'price_per_review'
]

# Set Streamlit page config
st.set_page_config(page_title="Airbnb Price Tier Classifier", layout="wide")

# Load model and encoder
@st.cache_resource
def load_model():
    model = joblib.load("models/airbnb_price_classifier_LightGBM.pkl")
    label_encoder = joblib.load("models/label_encoder.pkl")
    X_cols = joblib.load("models/X_cols.pkl")
    return model, label_encoder, X_cols

# Load once here so it's available
model, label_encoder, X_cols = load_model()

# App title
st.title("Airbnb Price Tier Classifier")
st.write("Upload your listing data and get predictions for price tier (Low, Mid, High).")

# File uploader
uploaded_file = st.file_uploader("Upload CSV file with listing data", type="csv")

# Show sample input format
with st.expander("Click to view expected column format"):
    st.markdown("""
    Required columns:
    - `room_type`, `latitude`, `longitude`, `minimum_nights`, `number_of_reviews`, `reviews_per_month`
    - `calculated_host_listings_count`, `availability_365`, `number_of_reviews_ltm`, `region_encoded`
    - `distance_to_region_center`, `host_experience_level`, `price_per_review`
    """)

# Prediction function
def make_predictions(df_input):
    df_encoded = pd.get_dummies(df_input, drop_first=True)
    df_encoded = df_encoded.reindex(columns=X_cols, fill_value=0)  # align with training features
    y_pred = model.predict(df_encoded)
    return label_encoder.inverse_transform(y_pred)

# SHAP explainer cache
@st.cache_resource
def get_explainer():
    return shap.TreeExplainer(model)

# Main logic
if uploaded_file:
    df_input = pd.read_csv(uploaded_file)

    # Validate
    missing_cols = set(features) - set(df_input.columns)
    if missing_cols:
        st.error(f"Missing required columns: {', '.join(missing_cols)}")
    else:
        # Display data
        st.subheader("Uploaded Data Preview")
        st.dataframe(df_input.head())

        # Predict
        st.subheader("🔮 Predicted Price Tier")
        predictions = make_predictions(df_input)
        df_input["Predicted Tier"] = predictions
        st.dataframe(df_input[["Predicted Tier"]])

        # SHAP
        st.subheader("SHAP Feature Importance (first 10 rows)")
        df_encoded = pd.get_dummies(df_input[features], drop_first=True)
        df_encoded = df_encoded.reindex(columns=X_cols, fill_value=0)

        explainer = get_explainer()
        shap_values = explainer.shap_values(df_encoded[:10])

        shap.summary_plot(shap_values, df_encoded[:10], class_names=label_encoder.classes_)
        st.pyplot(bbox_inches='tight')

# Load training feature columns for consistency
@st.cache_data
def load_training_columns():
    return joblib.load("/models/X_columns.pkl")
