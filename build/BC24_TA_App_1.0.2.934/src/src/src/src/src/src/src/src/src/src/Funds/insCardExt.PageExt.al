pageextension 50068 "Ins Card Ext" extends "Insurance Card"
{
    layout
    {
        addafter("Policy Coverage")
        {
            field("Payment Voucher No";"Payment Voucher No")
            {
                ApplicationArea = basic;
                
            }
            
        }
        addafter("Policy Coverage")
        {
            field("Next Reconcilition Date";"Next Reconcilition Date")
            {
                ApplicationArea = basic;
            }
        }
         addafter("Policy Coverage")
        {
            field("Invoice Period";"Invoice Period")
            {
                ApplicationArea = basic;
            }
        }
         addafter("Policy Coverage")
        {
            field("Posting Date";"Posting Date")
            {
                ApplicationArea = basic;
            }
        }
        addafter("Policy Coverage")
        {
            field("Installment Amount";"Installment Amount")
            {
                ApplicationArea=basic;
            }
        }
        addafter("Policy Coverage")
        {
            field("Next Invoice Date";"Next Invoice Date"){
                ApplicationArea=basic;
            }
        }
        addafter("Policy Coverage")
        {
            field("Next Invoice Period Start";"Next Invoice Period Start"){
                ApplicationArea=basic;
            }
        }
        addafter("Policy Coverage")
        {
            field("Next Invoice Period End";"Next Invoice Period End"){
                ApplicationArea=basic;
            }
        }
        addafter("Policy Coverage"){
            field(Prepaid;Prepaid){
                ApplicationArea=basic;
            }
        }
        
        }

    }
   