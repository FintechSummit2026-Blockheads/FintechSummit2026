
from datetime import datetime

from xrpl.models.transactions import EscrowCreate, EscrowFinish, EscrowCancel
from xrpl.utils import xrp_to_drops, datetime_to_ripple_time
from xrpl.transaction import submit_and_wait

from crypto.constants import CLIENT

def make_escrow(
    date_id, 
    your_wallet,
    date_addr,
    date_condition,
    stake,
    start_time_epoch,
    end_time_epoch,

):
    
    finish_after_ripple = datetime_to_ripple_time(datetime.fromtimestamp(start_time_epoch))
    cancel_after_ripple = datetime_to_ripple_time(datetime.fromtimestamp(end_time_epoch))
    
    escrow_create_tx = EscrowCreate(
        account=your_wallet.classic_address,
        amount=xrp_to_drops(stake),  # Stake XRP
        destination=date_addr,
        finish_after=finish_after_ripple,
        cancel_after=cancel_after_ripple,
        condition=date_condition
    )

    escrow_create_response = escrow_transaction(escrow_create_tx, CLIENT, your_wallet)
    sequence = escrow_create_response.result.get('tx_json', {}).get('Sequence')

    if not sequence:
        print('No sequence number found, stopping...')
        print('Full response:', escrow_create_response.result)
        return
    
    # TODO: update DB that your_wallet has created a date escrow to date in DATE_DB under date_id


def finish_escrow(
    date_id, 
    sequence,
    your_wallet,
    date_addr, 
    date_condition,
    date_fulfilment,
):
    
    escrow_finish_tx = EscrowFinish(
        account=your_wallet.classic_address,
        condition=date_condition,
        fulfillment=date_fulfilment,
        offer_sequence=sequence,
        owner=date_addr
    )
    
    escrow_finish_response = escrow_transaction(escrow_finish_tx, CLIENT, your_wallet)
    print(escrow_finish_response.result)

    # TODO: update DB that this escrow is finished
    

def cancel_escrow(
    your_wallet, 
    sequence,
):
    print('Canceling escrow...')
    escrow_cancel_tx = EscrowCancel(
        account=your_wallet.classic_address,  # The account submitting the cancel request
        owner=your_wallet.classic_address,    # The account that created the escrow
        offer_sequence=sequence               # The sequence number of the EscrowCreate transaction
    )
    
    escrow_cancel_response = escrow_transaction(escrow_cancel_tx, CLIENT, your_wallet)
    print(escrow_cancel_response.result)


def escrow_transaction(txn, client, wallet):
    """Submit an escrow transaction and wait for validation"""
    print(f'Submitting transaction: {txn.transaction_type}')
    
    try:
        response = submit_and_wait(txn, client, wallet)
        
        print(f'Transaction result: {response.result.get("meta", {}).get("TransactionResult", "Unknown")}')
        print(f'Transaction validated: {response.result.get("validated", False)}')
        
        return response
        
    except Exception as e:
        print(f'Error submitting transaction: {str(e)}')
        raise


