FROM python:3.11-slim

WORKDIR /app

# تنصيب Jupyter
RUN pip install jupyterlab pandas numpy matplotlib seaborn

# نسخ ملفات TP3 داخل الصورة
COPY . /app

# فتح بورت Jupyter
EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''"]
