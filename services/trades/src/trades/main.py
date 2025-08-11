import sys
from pathlib import Path
# Add the src directory to Python path
src_path = Path(__file__).parent.parent
sys.path.insert(0, str(src_path))
# Create an Application instance with Kafka configs
from quixstreams import Application
from trades.kraken_api import KrakenAPI, Trade
from typing import Optional
from loguru import logger


def run(
    kafka_broker_address: str,
    kafka_topic_name: str,
    # Old way to say an object if of this type or that type
    # kraken_api: Union[KrakenWebsocketAPI, KrakenRestAPI],
    # New way to say an object if of this type or that type
    kraken_api: KrakenAPI,
    kafka_topic_partitions: Optional[int] = 1,
):
    app = Application(
        broker_address=kafka_broker_address,
    )

    # Define a topic "my_topic" with JSON serialization
    topic = app.topic(
        name=kafka_topic_name,
        value_serializer='json',
        # You can use the from quixstreams.models import TopicConfig to configure the topic, if the topic does not exist yet.
        # config=TopicConfig(replication_factor=1, num_partitions=kafka_topic_partitions)
    )

    # Create a Producer instance
    with app.get_producer() as producer:
        while not kraken_api.is_done():
            # 1. Fetch the event from the external API
            events: list[Trade] = kraken_api.get_trades()
            # event = {"id": "1", "text": "Lorem ipsum dolor sit amet"}

            for event in events:
                # 2. Serialize an event using the defined Topic
                message = topic.serialize(
                    key=event.product_id, 
                    value=event.to_dict()
                )

                # 3. Produce a message into the Kafka topic
                producer.produce(
                    topic=topic.name, 
                    value=message.value, 
                    key=message.key
                )

                # logger.info(f'Produced message to topic {topic.name}')
                logger.info(f'Trade {event.to_dict()} pushed to Kafka')

            # breakpoint()


if __name__ == "__main__":
    api = KrakenAPI(product_ids=['BTC/EUR'])

    run(
        kafka_broker_address='localhost:31234',
        kafka_topic_name='trades',
        kraken_api=api,
    )