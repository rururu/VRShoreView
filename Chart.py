import streamlit as st
from util import *
import streamlit.components.v1 as components

st.set_page_config(
	layout="wide",
    page_title="Chart",
    page_icon=":globe_with_meridians:",
)
st.markdown(
    """
    <style>
    .main {
    background-color: #ddeeff;
    }
    </style>
    """,
    unsafe_allow_html=True
)

# Initial session state
if "chart" not in st.session_state:
	st.session_state["chart"] = None

# ---------------------------------- Web Page --------------------------------------

':blue[VR Chart]'

# Start Display Server
if st.session_state.chart is None:
    prb = st.progress(0)
    for cnt in range(100):
        time.sleep(0.02)
        prb.progress(cnt+1)
    st.session_state.chart = 'http://localhost:8448/chart'
    st.experimental_rerun()
else:
    components.iframe(st.session_state.chart, height=800)
