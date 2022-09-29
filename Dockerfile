FROM python:3.7

WORKDIR /app/

COPY . .

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN export PATH="/root/.cargo/bin:${PATH}"
ENV PATH="/root/.cargo/bin:${PATH}"

RUN pip3 install -r requirements.txt 

WORKDIR /app

EXPOSE 8000

CMD ["uvicorn", "backend.endpoints:router", "--host=0.0.0.0", "--reload"]