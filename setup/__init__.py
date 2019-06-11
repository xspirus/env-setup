import os

from dotenv import load_dotenv

__version__ = "0.1.0"
__root__ = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))

dotenv_path = os.path.join(__root__, ".env")
load_dotenv(dotenv_path=dotenv_path)
