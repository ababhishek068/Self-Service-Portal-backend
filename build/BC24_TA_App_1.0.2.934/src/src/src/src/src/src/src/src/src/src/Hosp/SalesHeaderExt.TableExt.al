tableextension 50015 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                if UserSetup.get(Database.UserId) then begin
                    "Shortcut Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
                    if Cust.get("Bill-to Customer No.") then
                        "Cash Sale" := Cust."Cash Customer";
                    if Cust."Cash Customer" = true then begin
                        UserSetup.testfield("Global Dimension 1 Code");
                        UserSetup.testfield("Global Dimension 2 Code");
                    end;

                end;
            end;
        }
        field(70134671; "Appointment No"; code[20]) { }
        field(70134672; "Patient No."; code[20]) { }
        field(70134673; "Treatment No"; code[20]) { }
        field(70134674; "Truck No"; code[20])
        {

            TableRelation = "Fixed Asset";
        }
        field(50067; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Shift Allocation".No where("Station Code" = field("Shortcut Dimension 1 Code"), Posted = filter(false));

        }
        field(50121; "Sales Person"; code[20])
        {
            // TableRelation = "Salesperson/Purchaser".Code where("Global Dimension 1 Code" = field("Global Dimension 1 Code"));
            TableRelation = "Shift Allocation Line"."Staff No" where(No = field("Shift No"));
        }
        field(70134678; "Invoice Cleared"; Boolean) { }
        field(50069; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum("Sales Line"."Amount Including VAT" where("Document No." = field("No.")));
        }
        field(70134679; "Receipt Amount"; Decimal) { }
        field(70134680; "Pay Mode"; option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,MPESA,PDQ';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,MPESA,PDQ;
            trigger OnValidate()
            var
                UserTemp: record "Cash Office User Template";
            begin
                "Cash Sale" := true;
                Validate("Cash Sale");
                if UserTemp.get(Database.UserId) then begin
                    if "Pay Mode" = "Pay Mode"::Cash then
                        "Bank Account No" := UserTemp."Default Receipts Bank";
                    if "Pay Mode" = "Pay Mode"::MPESA then
                        "Bank Account No" := UserTemp."Default MPESA Cash Bank";
                end;
            end;
        }
        field(70134681; "Bank Account No"; code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(70134682; "Cash Sale"; Boolean)
        {
            trigger OnValidate()
            var
                Cust: Record Customer;
                CashOfficeSetup: Record "Cash Office Setup";
            begin

                CashOfficeSetup.get;
                if Cust.get("Bill-to Customer No.") then
                    if Cust."Cash Customer" = true then begin
                        if "Cash Sale" = false then
                            Cust.TestField("Cash Customer", false);
                    end;
                if "Cash Sale" = true then
                    "Posting No. Series" := CashOfficeSetup."Cash Sale Invoice Nos";
            end;
        }
        field(70134683; "Transaction No"; code[20]) { }
    }

    var
        UserSetup: record "User Setup";
}