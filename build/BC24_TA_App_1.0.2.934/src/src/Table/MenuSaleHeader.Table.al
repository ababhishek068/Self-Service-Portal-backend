Table 50738 "Menu Sale Header"
{

    fields
    {
        field(1; "Receipt No"; Code[20]) { }
        field(2; Date; Date) { }
        field(3; "Cashier No"; Code[20])
        {
            TableRelation = Customer."No." where("Customer Posting Group" = const('IMPREST'));
        }
        field(4; "Customer Type"; Option)
        {
            OptionCaption = ', ,Staff,Department';
            OptionMembers = ," ",Staff,Department;
        }
        field(5; "Customer No"; Code[30])
        {
            TableRelation = Customer."No.";
        }
        field(6; "Customer Name"; Text[30]) { }
        field(7; "Receiving Bank"; Code[20])
        {
            TableRelation = "Bank Account"."No.";
        }
        field(8; Amount; Decimal)
        {
            CalcFormula = sum("Menu Sales Line".Amount where("Receipt No" = field("Receipt No")));
            FieldClass = FlowField;
        }
        field(9; Department; Code[30])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                /*DimVal.RESET;
                DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SETRANGE(DimVal.Code,"Shortcut Dimension 2 Code");
                 IF DimVal.FIND('-') THEN
                    "Budget Center Name":=DimVal.Name ;
                UpdateLines
                */

            end;
        }
        field(10; "Contact Staff"; Text[30]) { }
        field(11; "Sales Point"; Code[20])
        {
            TableRelation = "Catering Sale Points".Code;
        }
        field(12; "Paid Amount"; Decimal)
        {
            NotBlank = false;
        }
        field(13; Balance; Decimal) { }
        field(14; Posted; Boolean)
        {
            InitValue = false;
        }
        field(15; "Cashier Name"; Text[30]) { }
        field(16; "Sales Type"; Option)
        {
            OptionCaption = ' ,Cash,Credit,Prepayment,Mpesa,Pepea Card,BreakFast,Card Payments,Enterprise,Other Sales';
            OptionMembers = " ",Cash,Credit,Prepayment,Mpesa,"Pepea Card",BreakFast,"Card Payments",Enterprise,"Other Sales";

            trigger OnValidate()
            begin
                /* IF "Sales Type"="Sales Type"::Mpesa THEN
                 "Receiving Bank":=SalesSetUp."MPESA Receiving Bank Account";
                 IF "Sales Type"="Sales Type"::"Pepea Card" THEN
                 "Receiving Bank":=SalesSetUp."PEPEA  Receiving Bank Account";
                   */


            end;
        }
        field(17; "Prepayment Balance"; Decimal)
        {
            CalcFormula = sum("Catering Prepayment Ledger".Amount where("Customer No" = field("Customer No")));
            FieldClass = FlowField;
        }
        field(18; "Last Sc"; Text[100]) { }
        field(19; "Line Amount"; Decimal) { }
        field(20; "Daily Total Prepayment"; Decimal)
        {
            CalcFormula = sum("Menu Sale Header"."Line Amount" where("Cashier Name" = field("Cashier Name"),
                                                                      Date = field(Date),
                                                                      "Sales Type" = const(Prepayment)));
            FieldClass = FlowField;
        }
        field(21; "Daily Total Cash"; Decimal)
        {
            CalcFormula = sum("Menu Sale Header"."Line Amount" where("Cashier Name" = field("Cashier Name"),
                                                                      Date = field(Date),
                                                                      "Sales Type" = const(Cash)));
            FieldClass = FlowField;
        }
        field(22; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(23; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Menu Sale Header"."Line Amount" where("Cashier Name" = field("Cashier Name"),
                                                                      Date = field("Date Filter")));
            FieldClass = FlowField;
        }
        field(24; "Total Prepayment"; Decimal)
        {
            CalcFormula = sum("Menu Sale Header"."Line Amount" where("Cashier Name" = field("Cashier Name"),
                                                                      Date = field("Date Filter"),
                                                                      "Sales Type" = const(Prepayment)));
            FieldClass = FlowField;
        }
        field(25; "Total Cash"; Decimal)
        {
            CalcFormula = sum("Menu Sale Header"."Line Amount" where("Cashier Name" = field("Cashier Name"),
                                                                      Date = field("Date Filter"),
                                                                      "Sales Type" = const(Cash)));
            FieldClass = FlowField;
        }
        field(26; "BarCode No."; Code[20])
        {

            trigger OnValidate()
            begin
                cust.Reset;
                cust.SetRange(cust."Barcode No", "BarCode No.");
                if cust.Find('-') then begin
                    "Customer No" := cust."No.";
                    Modify;
                end;
            end;
        }
        field(27; "Transaction No."; Code[20]) { }
        field(28; Reversed; Boolean) { }
        field(29; "Reversed By"; Code[50]) { }
        field(30; "Reversed Date"; Date) { }
        field(31; "No. Series"; Code[20]) { }
    }

    keys
    {
        key(Key1; "Receipt No")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    begin
        /// IF Posted=TRUE THEN
        // ERROR('You cannot delete a posted transaction');
    end;

    trigger OnInsert()
    begin

        if "Receipt No" = '' then begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Receipt No");
            "Receipt No":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Receipt No", 0D, true);
        end;
        /*
         "Last No":='';
         "No Series".RESET;
         SalesSetUp.FINDLAST();
         "No Series".SETRANGE("No Series"."Series Code",'RECEIPT');
         IF "No Series".FIND('-') THEN
         BEGIN

           "Last No":="No Series"."Last No. Used";
           "No Series"."Last No. Used":=INCSTR("No Series"."Last No. Used");
           "No Series".MODIFY;
         END;

         "Receipt No":=INCSTR("Last No");
          */
        Date := Today;
        "Cashier No" := xRec."Cashier No";
        "Receiving Bank" := xRec."Receiving Bank";
        "Sales Type" := "sales type"::Cash;
        "Sales Point" := xRec."Sales Point";


        if UserSetup.Get(UserId) then begin
            "Sales Point" := UserSetup."Selling Point";
        end;

    end;

    trigger OnModify()
    begin
        // IF Posted=TRUE THEN
        //  ERROR('You cannot modify a posted transaction');
    end;

    trigger OnRename()
    begin
        // IF Posted=TRUE THEN
        // ERROR('You cannot modify a posted transaction');
    end;

    var
        cust: Record Customer;
        // BreakFast: Record "Catering Breakfast List";
        GenLedgerSetup: Record "Catering SetUp";
        NoSeriesMgt: Codeunit "No. Series";
        UserSetup: Record "User Setup";
}

