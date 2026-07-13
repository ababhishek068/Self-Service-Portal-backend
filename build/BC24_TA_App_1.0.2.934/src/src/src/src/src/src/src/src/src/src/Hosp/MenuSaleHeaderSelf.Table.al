Table 50663 "Menu Sale Header Self"
{

    fields
    {
        field(1; "Receipt No"; Code[20]) { }
        field(2; Date; Date) { }
        field(4; "Customer Type"; Option)
        {
            OptionCaption = ',Student ,Staff,Department,Posted';
            OptionMembers = ,"Student ",Staff,Department,Posted;
        }
        field(5; "Customer No"; Code[30])
        {
            TableRelation = Customer."No.";
        }
        field(6; "Customer Name"; Text[50]) { }
        field(11; "Sales Point"; Code[50])
        {
            TableRelation = "Catering Sale Points".Code;
        }
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
            FieldClass = Normal;
        }
        field(32; "Amount Totals"; Decimal) { }
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
        /*IF Posted=TRUE THEN
        ERROR('You cannot delete a posted transaction');  */

    end;

    trigger OnInsert()
    begin

        /*IF "Receipt No" = '' THEN BEGIN
          GenLedgerSetup.GET;
          GenLedgerSetup.TESTFIELD(GenLedgerSetup."Receipt No");
         NoSeriesMgt.GetNextNo(GenLedgerSetup."Receipt No",xRec."No. Series",0D,"Receipt No","No. Series");
        END;
         {
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
           }
          Date:=TODAY;
          "Cashier No":=xRec."Cashier No";
          "Receiving Bank":=xRec."Receiving Bank";
          "Sales Type":="Sales Type"::Cash;
          "Sales Point":=xRec."Sales Point";
           */

    end;

    trigger OnModify()
    begin
        /*IF Posted=TRUE THEN
         ERROR('You cannot modify a posted transaction');    */

    end;

    trigger OnRename()
    begin
        /* IF Posted=TRUE THEN
         ERROR('You cannot modify a posted transaction');    */

    end;
}

