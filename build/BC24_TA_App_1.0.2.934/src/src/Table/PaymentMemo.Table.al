table 50917 "Payment Memo"
{
    Caption = 'Payment Memo';
    DataClassification = ToBeClassified;
    LookupPageId = "Payment Requistions";
    fields
    {
        field(1; "Requisition No"; Code[30])
        {
            Caption = 'Requisition No';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(2; "Requisition Date"; Date)
        {
            Caption = 'Requisition Date';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(3; "Requisition Time"; Time)
        {
            Caption = 'Requisition Time';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; "Requesting User"; Text[100])
        {
            Caption = 'Requesting User';
            DataClassification = CustomerContent;
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
        field(5; "Supplier Invoice Number"; Code[30])
        {
            Caption = 'Supplier Invoice Number';
            DataClassification = CustomerContent;
            TableRelation = "Purch. Inv. Header"."No." where("Pay-to Vendor No." = field(Supplier), "Remaining Amount" = filter(<> 0));
            trigger OnValidate()
            begin
                pinvoice.Reset();
                pinvoice.SetRange(pinvoice."No.", "Supplier Invoice Number");
                if pinvoice.Find('-') then begin
                    "Invoice Due Date" := pinvoice."Due Date";
                    pinvoice.CalcFields("Amount Including VAT");
                    "Shortcut Dimension 1 Code" := pinvoice."Shortcut Dimension 1 Code";
                    "Shortcut Dimension 2 Code" := pinvoice."Shortcut Dimension 2 Code";
                    "Currency Code":=pinvoice."Currency Code";
                    ordno:=pinvoice."Order No.";
                    "Order No":=pinvoice."Order No.";
                //Validate(GRN);
                    // Get LCY
                    GLentry.RESET;
                    GLentry.SETRANGE(GLentry."Document No.", "Supplier Invoice Number");
                    if GLentry.Find('-') then begin
                        GLentry.CalcFields("Amount (LCY)");
                        "Due Amount" := GLentry."Amount (LCY)";
                    end;

                    "Due Amount" := pinvoice."Amount Including VAT";
                end;
            end;
        }
        field(6; "Supplier"; Code[30])
        {
            Caption = 'Supplier ';
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";

            trigger OnValidate()
            begin
                if vend.Get(Supplier) then
                    "Supplier Name" := vend.Name;
                "Posting Group" := vend."Vendor Posting Group";
            end;

        }

        field(7; "Supplier Name"; Text[100])
        {
            Caption = 'Supplier Name';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(8; "Invoice Due Date"; Date)
        {
            Caption = 'Invoice Due Date';
            DataClassification = CustomerContent;
        }
        field(9; "Due Amount"; Decimal)
        {
            Caption = 'Due Amount';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(10; "Payment Remarks"; Text[250])
        {
            Caption = 'Payment Remarks';
            DataClassification = CustomerContent;
        }
        field(11; "Supplier Delivery Note No"; Code[50])
        {
            Caption = 'Supplier Delivery Note No';
            DataClassification = CustomerContent;
        }
        field(12; "No Series"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(13; Status; Enum "Payment Approval Status")
        {
            DataClassification = ToBeClassified;
        }
        field(14; "Shortcut Dimension 1 Code"; code[30])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          Blocked = CONST(false));

        }
        field(15; "Shortcut Dimension 2 Code"; Code[30])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          Blocked = CONST(false));
        }
        field(16; "View Document"; code[30])
        {
            Caption = 'View Supplier Invoice';
            FieldClass = FlowField;
            CalcFormula = lookup("Purch. Inv. Header"."No." where("No." = field("Supplier Invoice Number")));
            Editable = false;

        }
        field(17; "Posting Group"; Code[30])

        {
            TableRelation = "Vendor Posting Group".Code;
            DataClassification = ToBeClassified;
        }
        field(18; "PV Number"; Code[30])
        {

            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Payments Header"."Reference No." where("Reference No." = field("Supplier Invoice Number")));
        }
        field(19;"Amount to Pay";Decimal){
            trigger OnValidate()
            var
            begin
                TestField("Due Amount");
                "Partial Payment":=false;
                if "Amount to Pay">"Due Amount" then begin
                    Error('You cannot overpay');
                end else begin
                    if "Amount to Pay"="Due Amount" then begin

                    end else if "Amount to Pay"<"Due Amount" then begin
                        "Partial Payment":=true;
                        Message('Please provide reason for the partial payment');
                    end;
                    
                end;
            end;
        }
        field(20;"Partial Payment";Boolean){Editable=false;}
        field(21;"Reason";Text[50]){}
        field(22;"Currency Code";Code[10]){Editable=false;}
        field(23; "GRN";Integer){
            Editable=false;
            FieldClass = FlowField;            
            CalcFormula = count("Purch. Rcpt. Header" where("Order No." = field("Order No"),"Pay-to Vendor No."=field(Supplier)));
            
          
        }
        field(24;"Order No";Code[20]){}
        field(25;"Document Type";Option){
            OptionMembers="Payment Memo",PV;
            
        }
    }
    keys
    {
        key(PK; "Requisition No")
        {
            Clustered = true;
        }

    }
    trigger OnInsert()
    begin
        if "Requisition No" = '' then begin
            CashOfficeSetup.Get();
            CashOfficeSetup.TestField("Payment Schedule No");
            "Requisition No" := noseries.GetNextNo(CashOfficeSetup."Payment Schedule No", Today, true);
            "Requesting User" := UserId;
            "Requisition Date" := Today;
            "Requisition Time" := Time;
            "Partial Payment":=false;
            "Currency Code":='';
        end;
    end;

    internal procedure ConvertToPaymentVoucher()
    var
        newPVNo: Code[20];
        NoSeriesMgmt: Codeunit "No. Series";
        CashOfficeSetup: Record "Cash Office Setup";
    begin
        PVHeader.Reset();
        PVHeader.SetRange(PVHeader."Reference No.", "Supplier Invoice Number");
        if PVHeader.Find('-') then
            Error("Supplier Invoice Number" + ' ' + 'has already been paid');
        CashOfficeSetup.Get();
        CashOfficeSetup.TestField(CashOfficeSetup."Normal Payments No");
        newPVNo := NoSeriesMgmt.GetNextNo(CashOfficeSetup."Normal Payments No", 0D, true);
        PVHeader.Init();
        PVHeader."No." := newPVNo;
        PVHeader.Date := Today;
        PVHeader."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
        PVHeader."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
        PVHeader."Payment Narration" := "Payment Remarks";
        PVHeader.Payee := "Supplier Name";
        PVHeader."On Behalf Of" := "Requesting User";
        PVHeader."Payment Type" := PVHeader."Payment Type"::Normal;
        PVHeader."Reference No." := "Supplier Invoice Number";
        PVHeader.Insert();
        PVHeader.Validate("Global Dimension 1 Code");
        PVHeader.Validate("Shortcut Dimension 2 Code");

        PVLines.Init();
        PVLines.No := newPVNo;
        PVLines.Date := PVHeader.Date;
        PVLines.Type := 'Vend';
        PVLines.Validate(Type);
        PVLines."Account Type" := PVLines."Account Type"::Vendor;
        PVLines.Grouping := "Posting Group";
        PVLines.Validate("Account Type");
        PVLines."Account No." := Supplier;
        PVLines.Validate("Account No.");
        PVLines."Applies-to Doc. Type" := PVLines."Applies-to Doc. Type"::Invoice;
        PVLines.Amount := "Due Amount";
        PVLines.Insert();

        Modify();
        PVHeader.UpdateLines();
        Message('Generated PV No is %1', newPVNo);
        PVHeader.Reset();
        PVHeader.SetRange(PVHeader."No.", newPVNo);
        if PVHeader.Find('-') then begin
            Page.Run(51381, PVHeader);
        end;
    end;


    //*********OPEN Record


    //end;



    var
        noseries: Codeunit "No. Series";
        vend: Record Vendor;
        pinvoice: Record "Purch. Inv. Header";
        CashOfficeSetup: Record "Cash Office Setup";
        PVHeader: Record "Payments Header";
        PVLines: Record "Payment Line";
        GLentry: record "Vendor Ledger Entry";
        ordno: code[20];
}
