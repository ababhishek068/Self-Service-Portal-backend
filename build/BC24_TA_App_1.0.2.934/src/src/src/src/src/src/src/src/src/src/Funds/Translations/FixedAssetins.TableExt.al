tableextension 50052 "Fixed Asset Ins" extends Insurance
{
    fields
    {
        field(50000; "Next Reconcilition Date"; Date)
        {
            Caption = 'Next Reconcilition Date';
            DataClassification = CustomerContent;
             trigger OnValidate()
                var
                begin
                    if Rec."Next Reconcilition Date">Today then begin

                    end else if Rec."Next Reconcilition Date"<=Today then
                    Error('Date must be greater than today');


                end;
        }
        field(50001; "Payment Voucher No"; Code[20])
        {
            Caption = 'Payment Voucher No';
            DataClassification = CustomerContent;
        }
        field(50002; "Installment Amount"; Decimal)
        {
            Caption = 'Installment Amount per Reconciliation';
            DataClassification = CustomerContent;
        }


        field(50003; "Invoice Period"; Enum "Service Contract Header Invoice Period")
        {
            Caption = 'Invoice Period';
            trigger OnValidate()
            begin
                TestField("Posting Date");
                case "Invoice Period" of
                    "Invoice Period"::Month:
                        "Next Invoice Date" := CalcDate('<1M>', "Posting Date");
                    "Invoice Period"::"Two Months":
                        "Next Invoice Date" := CalcDate('<2M>', "Posting Date");
                    "Invoice Period"::Quarter:
                        "Next Invoice Date" := CalcDate('<3M>', "Posting Date");
                    "Invoice Period"::"Half Year":
                        "Next Invoice Date" := CalcDate('<6M>', "Posting Date");
                    "Invoice Period"::Year:
                        "Next Invoice Date" := CalcDate('<12M>', "Posting Date");
                    "Invoice Period"::None:
                        if Prepaid then
                            "Next Invoice Date" := 0D;
                end;
                if not Prepaid and ("Next Invoice Date" <> 0D) then
                    "Next Invoice Date" := CalcDate('<CM>', "Next Invoice Date");

                // if ("Last Invoice Date" <> 0D) and ("Last Invoice Date" <> xRec."Last Invoice Date") then
                //     if Prepaid then
                //         Validate("Last Invoice Period End", "Next Invoice Period End")
                //     else
                //         Validate("Last Invoice Period End", "Last Invoice Date");

                Validate("Next Invoice Date");
            end;
            

        
        }
        field(50004; "Last Invoice Date"; Date)
        {
            Caption = 'Last Invoice Date';
            Editable = false;

            
        }
        field(50005; "Next Invoice Date"; Date)
        {
            Caption = 'Next Invoice Date';
            Editable = false;

        }
        
        field(50011; "Amount per Period"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            Caption = 'Amount per Period';
            Editable = false;
        }

        field(50012; "Next Invoice Period Start"; Date)
        {
            Caption = 'Next Invoice Period Start';
            Editable = false;
        }
        field(50013; "Next Invoice Period End"; Date)
        {
            Caption = 'Next Invoice Period End';
            Editable = false;
        }
        field(45; Prepaid; Boolean)
        {
            Caption = 'Prepaid';
        }
        field(46;"Posting Date";Date){
            Editable=true;
            Caption='Posting Date';
            
        }
        
    
    }
    var
        emplist: Record "HR-Employee";
        itemcat: Record "Item Category";
        TempDate: Date;
        itemsub: Record "Item Subcategory";
}