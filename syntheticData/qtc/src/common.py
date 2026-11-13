"""Shared constants for the synthetic QTc study.

Concept ids in the 2082499xxx range are the existing WAVEFORM vocabulary delta
(see ../../vocab_temp/concept_delta.csv). Concept ids in the 2082599xxx range
are TUTORIAL-LOCAL PLACEHOLDERS for things the vocabulary does not define yet
(derived ECG measurements, algorithms, units, the two synthetic drugs). They
are listed in data/omop/concept.csv so every id in the dataset can be joined.
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "data"
OMOP = DATA / "omop"
WFE = DATA / "waveform_extension"
WFDB = DATA / "wfdb"
KEY = DATA / "answer_key"

SEED = 20261113
FS = 250                      # Hz
DURATION_S = 10
GAIN = 1000                   # ADU per mV, 16-bit signed (WFDB format 16)
LEADS = ["I", "II", "III"]

# --- WAVEFORM vocabulary delta (existing) --------------------------------
C_DIAGNOSTIC_ECG = 2082499974
C_WFDB = 2082499975
C_HEA = 2082499961
C_DAT = 2082499965
C_SAMPLERATE = 2082499968
C_RESOLUTION = 2082499969
C_SPS = 2082499972
C_LOW_QUALITY = 2082499971
C_LEAD = {"I": 2082499990, "II": 2082499966, "III": 2082499947}
C_ADU_PER_MV = 9484           # as used in ../../createSimpleSyntheticSet.sql

# --- standard OMOP concepts ------------------------------------------------
C_FEMALE, C_MALE = 8532, 8507
C_INPATIENT = 9201
C_HEART_FAILURE = 316139
C_HYPERTENSION = 320128
C_T2DM = 201826
C_POTASSIUM = 3023103          # Potassium [Moles/volume] in Serum or Plasma
C_MMOL_L = 8753
C_LAB_TYPE = 44818702

# --- tutorial-local placeholders ------------------------------------------
LOCAL = {
    2082599101: ("QTc interval, Fridericia", "Measurement", "Tutorial placeholder"),
    2082599102: ("QTc interval, Bazett", "Measurement", "Tutorial placeholder"),
    2082599103: ("QT interval", "Measurement", "Tutorial placeholder"),
    2082599104: ("Heart rate from ECG", "Measurement", "Tutorial placeholder"),
    2082599105: ("QRS duration", "Measurement", "Tutorial placeholder"),
    2082599106: ("RR interval", "Measurement", "Tutorial placeholder"),
    2082599107: ("ECG high-frequency noise level", "Measurement", "Tutorial placeholder"),
    2082599201: ("Tutorial threshold ECG interval detector v1", "Metadata", "Tutorial placeholder"),
    2082599202: ("Bazett correction applied to detector output", "Metadata", "Tutorial placeholder"),
    2082599203: ("Fridericia correction applied to detector output", "Metadata", "Tutorial placeholder"),
    2082599301: ("millisecond", "Unit", "Tutorial placeholder"),
    2082599302: ("beats per minute", "Unit", "Tutorial placeholder"),
    2082599303: ("millivolt", "Unit", "Tutorial placeholder"),
    2082599310: ("Derived from waveform feature", "Type Concept", "Tutorial placeholder"),
    2082599401: ("Synthetic antiemetic A (QT-prolonging)", "Drug", "Tutorial placeholder"),
    2082599402: ("Synthetic antiemetic B (comparator, no QT effect)", "Drug", "Tutorial placeholder"),
}
C_QTCF, C_QTCB, C_QT, C_HR, C_QRS, C_RR, C_NOISE = (2082599101, 2082599102, 2082599103,
                                                    2082599104, 2082599105, 2082599106, 2082599107)
C_ALGO, C_ALGO_BAZETT, C_ALGO_FRIDERICIA = 2082599201, 2082599202, 2082599203
C_MS, C_BPM, C_MV = 2082599301, 2082599302, 2082599303
C_DERIVED_TYPE = 2082599310
C_DRUG_A, C_DRUG_B = 2082599401, 2082599402

STANDARD_NAMES = {
    8532: ("FEMALE", "Gender"), 8507: ("MALE", "Gender"), 9201: ("Inpatient Visit", "Visit"),
    316139: ("Heart failure", "Condition"), 320128: ("Essential hypertension", "Condition"),
    201826: ("Type 2 diabetes mellitus", "Condition"),
    3023103: ("Potassium [Moles/volume] in Serum or Plasma", "Measurement"),
    8753: ("millimole per liter", "Unit"), 44818702: ("Lab result", "Type Concept"),
    2082499974: ("Diagnostic ECG", "Procedure"), 2082499975: ("WFDB", "WFE File Format"),
    2082499961: ("HEA", "WFE File Format"), 2082499965: ("DAT", "WFE File Format"),
    2082499968: ("SAMPLERATE", "WFE Lead"), 2082499969: ("RESOLUTION", "WFE Lead"),
    2082499972: ("sps", "Unit"), 2082499971: ("Low signal quality", "Qualifier Value"),
    2082499990: ("I", "WFE Lead"), 2082499966: ("II", "WFE Lead"), 2082499947: ("III", "WFE Lead"),
    9484: ("ADU/mV", "Unit"),
}
