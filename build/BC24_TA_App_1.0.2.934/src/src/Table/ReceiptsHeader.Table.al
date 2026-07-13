Table 50906 "Receipts Header"
{

    fields
    {
        field(1; "No."; Code[20])
        {
            Description = 'Stores the code of the receipt in the database';
        }
        field(2; Date; Date)
        {
            Description = 'Stores the date when the receipt was entered into the system';
        }
        field(3; Cashier; Code[30])
        {
            Description = 'Stores the user id of the cashier';
        }
        field(4; "Date Posted"; Date) { }
        field(5; "Time Posted"; Time) { }
        field(6; Posted; Boolean) { }
        field(7; "No. Series"; Code[20]) { }
        field(8; "Bank Code"; Code[20])
        {
            TableRelation = "Bank Account"."No.";

            trigger OnValidate()
            begin
                /*
                IF PayLinesExist THEN BEGIN
                ERROR('You first need to delete the existing Receipt lines before changing the Currency Code'
                );
                END;
                */
                if bank.Get("Bank Code") then begin
                    "Bank Name" := bank.Name;
                    "Currency Code" := bank."Currency Code";
                end;

            end;
        }
        field(9; "Received From"; Text[100]) { }
        field(10; "On Behalf Of"; Text[100]) { }
        field(11; "Amount Recieved"; Decimal)
        {
            DecimalPlaces = 0 : 15;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(27; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(29; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code'
                    );
                end else begin
                    "Bank Code" := '';
                end;
            end;
        }
        field(30; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(38; "Total Amount"; Decimal)
        {
            CalcFormula = sum("Receipt Line q".Amount where(No = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            DecimalPlaces = 0 : 15;
        }
        field(39; "Posted By"; Code[20]) { }
        field(40; "Print No."; Integer) { }
        field(41; Status; Option)
        {
            OptionMembers = " ",Normal,"Post Dated",Posted,Partial,Cancelled;
        }
        field(42; "Cheque No."; Code[20]) { }
        field(43; "No. Printed"; Integer) { }
        field(44; "Created By"; Code[50]) { }
        field(45; "Created Date Time"; DateTime) { }
        field(46; "Register No."; Integer) { }
        field(47; "From Entry No."; Integer) { }
        field(48; "To Entry No."; Integer) { }
        field(49; "Document Date"; Date) { }
        field(81; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin
                if PayLinesExist then begin
                    Error('You first need to delete the existing Receipt lines before changing the Currency Code'
                    );
                end else begin
                    //"Bank Code":='';
                end;


                TestField(Status, Status::" ");
                if not UserMgt.CheckRespCenter(1, "Responsibility Center") then
                    Error(
                      Text001,
                      RespCenter.TableCaption, UserMgt.GetPurchasesFilter);
                /*
               "Location Code" := UserMgt.GetLocation(1,'',"Responsibility Center");
               IF "Location Code" = '' THEN BEGIN
                 IF InvtSetup.GET THEN
                   "Inbound Whse. Handling Time" := InvtSetup."Inbound Whse. Handling Time";
               END ELSE BEGIN
                 IF Location.GET("Location Code") THEN;
                 "Inbound Whse. Handling Time" := Location."Inbound Whse. Handling Time";
               END;

               UpdateShipToAddress;
                  */
                /*
             CreateDim(
               DATABASE::"Responsibility Center","Responsibility Center",
               DATABASE::Vendor,"Pay-to Vendor No.",
               DATABASE::"Salesperson/Purchaser","Purchaser Code",
               DATABASE::Campaign,"Campaign No.");

             IF xRec."Responsibility Center" <> "Responsibility Center" THEN BEGIN
               RecreatePurchLines(FIELDCAPTION("Responsibility Center"));
               "Assigned User ID" := '';
             END;
               */

            end;
        }
        field(83; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 3 Code");
                if DimVal.Find('-') then
                    Dim3 := DimVal.Name
            end;
        }
        field(84; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                DimVal.Reset;
                //DimVal.SETRANGE(DimVal."Global Dimension No.",2);
                DimVal.SetRange(DimVal.Code, "Shortcut Dimension 4 Code");
                if DimVal.Find('-') then
                    Dim4 := DimVal.Name
            end;
        }
        field(86; Dim3; Text[250]) { }
        field(87; Dim4; Text[250]) { }
        field(88; "Bank Name"; Text[250]) { }
        field(89; "Receipt Reference"; Option)
        {
            Editable = false;
            OptionMembers = Normal,"Travel Advance Refunds","Other Advance Refunds";
        }
        field(90; "Staff Number"; Code[20]) { }
        field(50000; "Patient No."; Code[20])
        {
            // TableRelation = "HMS Patient"."Patient No.";
            /*
                        trigger OnValidate()
                        begin
                            RLine.Reset;
                            RLine.SetRange(RLine.No, "No.");
                            if RLine.Find('-') then RLine.DeleteAll;

                            if RLine.FindLast() then LineNo := RLine."Line No." + 1;

                            PatientCharges.Reset;
                            PatientCharges.SetRange(PatientCharges."Patient No.", "Patient No.");
                            PatientCharges.SetRange(PatientCharges.Posted, false);
                            if PatientCharges.Find('-') then begin
                                repeat
                                    RLine.Init;
                                    RLine."Line No." := LineNo + 1;
                                    RLine.No := "No.";
                                    RLine.Type := 'HOSP';
                                    PatientCharges.CalcFields("G/L Account");
                                    RLine."Account No." := PatientCharges."G/L Account";
                                    RLine.Validate(RLine."Account No.");
                                    RLine."Transaction Name" := PatientCharges.Description;
                                    RLine."Pay Mode" := RLine."pay mode"::Cash;
                                    RLine.Amount := PatientCharges.Amount;
                                    RLine."Transaction Name" := PatientCharges.Code;
                                    RLine.Insert(true);
                                    LineNo := LineNo + 1;
                                until PatientCharges.Next = 0;
                            end;

                            PharmLine.Reset;
                            PharmLine.SetRange(PharmLine."Patient No", "Patient No.");
                            if PharmLine.Find('-') then begin
                                HMSSetup.Get();
                                HMSSetup.TestField("Pharmacy G/L Account");
                                repeat
                                    RLine.Init;
                                    RLine."Line No." := LineNo + 1;
                                    RLine.No := "No.";
                                    RLine.Type := 'HOSP';
                                    // RLine."Sell-to Customer No.":="Sell-to Customer No.";
                                    RLine."Account Type" := RLine."account type"::"G/L Account";
                                    RLine."Account No." := HMSSetup."Pharmacy G/L Account";
                                    RLine.Validate(RLine.No);
                                    RLine."Transaction Name" := PharmLine."Drug Name";
                                    RLine."Pay Mode" := RLine."pay mode"::Cash;
                                    RLine.Amount := PharmLine."Issued Price";

                                    // RLine.Amount:=;
                                    RLine.Insert(true);
                                    LineNo := LineNo + 1;
                                until PharmLine.Next = 0;
                            end;
                        end;
                        */
        }
        field(50001; "Patient Appointment No"; Code[20])
        {
            /*
            TableRelation = "HMS Appointment Form Header"."Appointment No." where("Patient No." = field("Patient No."));

            trigger OnValidate()
            begin
                if "Patient Appointment No" <> '' then begin
                    Amt := 0;
                    HMSLabLine.Reset;
                    HMSLabLine.SetRange(HMSLabLine."Link No", "Patient Appointment No");
                    if HMSLabLine.Find('-') then begin
                        "Bank Code" := '2004027';
                        "Global Dimension 1 Code" := 'MAIN';
                        "Shortcut Dimension 2 Code" := '01-02-D031';

                        repeat
                            LineNo := LineNo + 1;
                            RLine.Init;
                            RLine."Line No." := LineNo;
                            RLine.No := "No.";
                            RLine.Type := '103';
                            RLine.Validate(Type);
                            RLine."Bank Code" := '2004027';
                            RLine."Pay Mode" := RLine."pay mode"::Cash;
                            RLine."Cheque/Deposit Slip Date" := Date;
                            RLine."Received From" := "Received From";
                            RLine.Amount := HMSLabLine.Amount;
                            RLine.Validate(Amount);
                            Amt := Amt + HMSLabLine.Amount;
                            RLine."Transaction Name" := HMSLabLine.Description;
                            RLine."Transaction No." := HMSLabLine."Link No";
                            RLine.Insert;
                            "Amount Recieved" := Amt;
                        until HMSLabLine.Next = 0;
                    end;
                end;
            end;
            */
        }
        field(50002; "Surrender No"; Code[20]) { }
        field(50003; "Manual Ref.Number"; Text[30]) { }
        field(50004; "Imprest No"; Code[20])
        {
            TableRelation = "Imprest Header"."No." where(Status = const(Approved));
        }

        field(50008; "Pay Mode1"; Option)
        {
            CalcFormula = lookup("Receipt Line q"."Pay Mode" where(No = field("No.")));
            FieldClass = FlowField;
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,MPESA,PDQ';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,MPESA,PDQ;
        }
        field(50009; "Pharmacy No"; Code[20])
        {
            /*
            TableRelation = "HMS Pharmacy Header"."Pharmacy No." where("Cash Sale" = const(Yes), "Receipt Count" = filter(0));

            trigger OnValidate()
            begin
                Amt := 0;
                PharmLine.Reset;
                PharmLine.SetRange(PharmLine."Pharmacy No.", "Pharmacy No");
                if PharmLine.Find('-') then begin
                    "Bank Code" := '2004027';
                    "Global Dimension 1 Code" := 'MAIN';
                    "Shortcut Dimension 2 Code" := '01-02-D031';
                    if PharmRec.Get("Pharmacy No") then begin
                        "Cash Mode" := PharmRec."Mode of Cash";
                        PharmRec.CalcFields(PharmRec."Insurance No");
                        PharmRec.CalcFields("Patient Type");
                    end;
                    repeat
                        LineNo := LineNo + 5;
                        RLine.Init;
                        RLine."Line No." := LineNo;
                        RLine.No := "No.";
                        RLine.Type := '103';
                        if PharmRec."Insurance No" <> '' then
                            if PharmRec."Patient Type" <> PharmRec."patient type"::Student then
                                RLine.Type := '199';
                        RLine.Validate(Type);
                        RLine."Pay Mode" := RLine."pay mode"::Cash;
                        RLine."Cheque/Deposit Slip Date" := Date;
                        RLine."Bank Code" := '2004027';
                        RLine."Received From" := "Received From";
                        RLine.Amount := PharmLine."Issued Price";
                        RLine.Validate(Amount);
                        Amt := Amt + PharmLine."Issued Price";
                        PharmLine.CalcFields("Drug Name");
                        RLine."Transaction Name" := PharmLine."Drug Name";
                        RLine."Transaction No." := PharmLine."Pharmacy No.";
                        RLine.Insert;

                    until PharmLine.Next = 0;
                    "Amount Recieved" := Amt;
                end;
            end;
            */
        }
        field(50010; "Laboratory No"; Code[20])
        {
            /*
            FieldClass = Normal;
            TableRelation = "HMS Laboratory Form Header"."Laboratory No." where("Cash Sale" = filter(Yes), "Receipt Count" = filter(0));

            trigger OnValidate()
            begin
                if "Laboratory No" <> '' then begin
                    Amt := 0;
                    HMSLabLine.Reset;
                    HMSLabLine.SetRange(HMSLabLine."Link No", "Laboratory No");
                    if HMSLabLine.Find('-') then begin
                        "Bank Code" := '2004027';
                        "Global Dimension 1 Code" := 'MAIN';
                        "Shortcut Dimension 2 Code" := '01-02-D031';
                        if LabRec.Get("Laboratory No") then begin
                            "Cash Mode" := LabRec."Mode of Cash";
                            LabRec.CalcFields("Settlement Type");
                            LabRec.CalcFields("Patient Type");
                        end;
                        repeat
                            LineNo := LineNo + 10;
                            RLine.Init;
                            RLine."Line No." := LineNo;
                            RLine.No := "No.";
                            RLine.Type := '103';
                            if LabRec."Settlement Type" = LabRec."settlement type"::Insurance then
                                if LabRec."Patient Type" <> LabRec."patient type"::Student then
                                    RLine.Type := '199';

                            RLine.Validate(Type);
                            RLine."Bank Code" := '2004027';
                            RLine."Pay Mode" := RLine."pay mode"::Cash;
                            RLine."Cheque/Deposit Slip Date" := Date;
                            RLine."Received From" := "Received From";
                            RLine.Amount := HMSLabLine.Amount;
                            RLine.Validate(Amount);
                            Amt := Amt + HMSLabLine.Amount;
                            RLine."Transaction Name" := HMSLabLine.Description;
                            RLine."Transaction No." := HMSLabLine."Link No";
                            RLine.Insert;
                            "Amount Recieved" := Amt;
                        until HMSLabLine.Next = 0;
                    end;
                end;
            end;
            */
        }
        field(50011; "Physiotheraphy No"; Code[20])
        {
            /*
            Description = 'HMS Physiotheraphy Form Header';
            TableRelation = "Cafeteria Closure Procedures"."Cafe Clossing Date" where(Code = const(0));

            trigger OnValidate()
            begin
                if "Laboratory No" <> '' then begin
                    Amt := 0;
                    PatientCharges.Reset;
                    PatientCharges.SetRange(PatientCharges."Link No", "Physiotheraphy No");
                    if PatientCharges.Find('-') then begin
                        "Bank Code" := '2004027';
                        "Global Dimension 1 Code" := 'MAIN';
                        "Shortcut Dimension 2 Code" := '01-02-D031';
                        if PhysioRec.Get("Physiotheraphy No") then
                            "Cash Mode" := PhysioRec."Mode of Cash";
                        if AppH.Get(PhysioRec."Link No.") then;
                        repeat
                            LineNo := LineNo + 20;
                            RLine.Init;
                            RLine."Line No." := LineNo;
                            RLine.No := "No.";
                            RLine.Type := '103';
                            if AppH."Settlement Type" = AppH."settlement type"::Insurance then
                                if AppH."Patient Type" <> AppH."patient type"::Student then
                                    RLine.Type := '199';

                            RLine.Validate(Type);
                            RLine."Bank Code" := '2004027';
                            RLine."Pay Mode" := RLine."pay mode"::Cash;
                            RLine."Cheque/Deposit Slip Date" := Date;
                            RLine."Received From" := "Received From";
                            RLine.Amount := PatientCharges.Amount;
                            RLine.Validate(Amount);
                            Amt := Amt + PatientCharges.Amount;
                            RLine."Transaction Name" := PatientCharges.Description;
                            RLine."Transaction No." := PatientCharges."Link No";
                            RLine.Insert;
                            "Amount Recieved" := Amt;
                        until PatientCharges.Next = 0;
                    end;
                end;
            end;
            */
        }
        field(50012; "Posted Count"; Integer)
        {
            CalcFormula = count("Bank Account Ledger Entry" where("Document No." = field("No.")));
            FieldClass = FlowField;
        }
        field(50013; "Cash Mode"; Option)
        {
            Editable = false;
            OptionCaption = ' ,Cash,MPESA';
            OptionMembers = " ",Cash,MPESA;
        }
        field(50014; "Fully Disbursed"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Disbursable Amount"; Decimal)
        {
            CalcFormula = sum("Receipt Line q".Amount where("Allow Disbursment" = const(true), No = field("No.")));
            FieldClass = FlowField;
        }

        field(50017; "InterBank No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50097; "Invoice No"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Sales Invoice Header"."No.";
        }
        field(50018; "InterBank No Filter"; Code[20])
        {
            FieldClass = FlowFilter;
        }
        field(50019; "Pay Mode"; Option)
        {
            FieldClass = Normal;
            OptionCaption = ' ,Cash,Cheque,EFT,Deposit Slip,Banker''s Cheque,RTGS,MPESA,PDQ';
            OptionMembers = " ",Cash,Cheque,EFT,"Deposit Slip","Banker's Cheque",RTGS,MPESA,PDQ;
            trigger OnValidate()
            var
                UserTemp: Record "Cash Office User Template";
                RecLine: Record "Receipt Line q";
            begin

                if UserTemp.get(Database.UserId) then begin
                    if "Pay Mode" <> "Pay Mode"::MPESA then
                        "Bank Code" := UserTemp."Default Receipts Bank"
                    else
                        "Bank Code" := UserTemp."Default MPESA Cash Bank";
                    Validate("Bank Code");
                end;
                RecLine.reset;
                Recline.setrange(No, "No.");
                if Recline.find('-') then begin
                    repeat
                        Recline."Pay Mode" := "Pay Mode";
                        Recline.modify;
                    until Recline.next = 0;
                end
            end;
        }
        field(50020; "Customer No"; code[20])
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Receipt Line q"."Account No." where(No = field("No.")));
        }
        field(50021; "Sales Person"; code[20])
        {
            // TableRelation = "Salesperson/Purchaser".Code where("Global Dimension 1 Code" = field("Global Dimension 1 Code"));
            TableRelation = "Shift Allocation Line"."Staff No" where(No = field("Shift No"));
        }
        field(50067; "Shift No"; code[20])
        {
            DataClassification = ToBeClassified;
            //  TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"));
            TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"), Open = const(true), Posted = const(false));

        }
        field(50068; "Shift Discount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Shift Allocation"."Special Discount Amount" where(No = field("Shift No")));
            // TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"));

        }
        field(50069; "Customer Name"; text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No")));

        }
        field(50070; "Customer Category"; text[100])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Customer Category" where("No." = field("Customer No")));

        }
        field(50169; "Reversed"; Boolean)
        {
            FieldClass = FlowField;
            CalcFormula = lookup("Bank Account Ledger Entry".Reversed where("Document No." = field("No.")));
            // TableRelation = "Shift Allocation".No where("Station Code" = field("Global Dimension 1 Code"));
            trigger OnValidate()
            begin
                Reversed2 := Reversed;
                Modify()
            end;

        }
        field(50170; "Reversed2"; Boolean) { }

        field(50171; "Negotiated Exchange Rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 15;
            trigger OnValidate()
            begin
                // UpdateCurrencyFactor();
            end;
        }
        field(50172; Description; text[100])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        // IF "No." = '' THEN BEGIN
        //  GenLedgerSetup.GET;
        //  GenLedgerSetup.TESTFIELD(GenLedgerSetup."Receipts No");
        //  NoSeriesMgt.GetNextNo(GenLedgerSetup."Receipts No",xRec."No. Series",0D,"No.","No. Series");
        // END;

        UserTemplate.Reset;
        UserTemplate.SetRange(UserTemplate.UserID, UserId);
        if UserTemplate.FindFirst then begin
            "Bank Code" := UserTemplate."Default Receipts Bank";
            Validate("Bank Code");
            Cashier := UserId;
        end;
        if "Bank Code" <> '' then begin
            BankRec.Get("Bank Code");
            BankRec.TestField("Receipt No. Series");
            "No.":=NoSeriesMgt.GetNextNo(BankRec."Receipt No. Series",  0D, true);
        end else begin
            GenLedgerSetup.Get;
            GenLedgerSetup.TestField(GenLedgerSetup."Receipts No");
            "No.":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Receipts No",  0D, true);
        end;
        //*****************************JACK**************************//
        "Created By" := UserId;
        "Created Date Time" := CreateDatetime(Today, Time);
        //*****************************END***************************//
        RHead.Reset;
        RHead.SetFilter("No.", '<>%1', "No.");
        RHead.SetFilter("Created By", UserId);
        if RHead.Find('-') then begin
            "Global Dimension 1 Code" := RHead."Global Dimension 1 Code";
            "Shortcut Dimension 2 Code" := RHead."Shortcut Dimension 2 Code";
            "Bank Code" := RHead."Bank Code";
        end;
    end;

    trigger OnModify()
    begin
        RLine.Reset;
        RLine.SetRange(RLine.No, "No.");
        if RLine.FindFirst then begin
            repeat
                RLine."Global Dimension 1 Code" := "Global Dimension 1 Code";
                RLine."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
                RLine."Shortcut Dimension 3 Code" := "Shortcut Dimension 3 Code";
                RLine."Shortcut Dimension 4 Code" := "Shortcut Dimension 4 Code";
                RLine.Modify;
            until RLine.Next = 0;
        end;
    end;

    var
        GenLedgerSetup: Record "Cash Office Setup";
        NoSeriesMgt: Codeunit "No. Series";
        UserTemplate: Record "Cash Office User Template";
        RLine: Record "Receipt Line q";
        RespCenter: Record "Responsibility Center BR";
        UserMgt: Codeunit "User Setup Management BR";
        Text001: label 'Your identification is set up to process from %1 %2 only.';
        DimVal: Record "Dimension Value";
        bank: Record "Bank Account";
        // PharmRec: Record UnknownRecord70135034;
        //  LabRec: Record UnknownRecord70135027;
        // PhysioRec: Record UnknownRecord70134995;
        // AppH: Record UnknownRecord70135014;
        BankRec: Record "Bank Account";
        RHead: Record "Receipts Header";


    procedure PayLinesExist(): Boolean
    begin
        RLine.Reset;
        RLine.SetRange(RLine.No, "No.");
        exit(RLine.FindFirst);
    end;

    procedure AssistEdit(OldCust: Record "Receipts Header"): Boolean
    var
        Cust: Record "Receipts Header";
    begin
        Cust := Rec;

        GenLedgerSetup.Get;
        GenLedgerSetup.TestField(GenLedgerSetup."Receipts No");

        Cust."No.":=NoSeriesMgt.GetNextNo(GenLedgerSetup."Receipts No", 0D,true);
            //NoSeriesMgt.SetSeries();
            Rec := Cust;
            exit(true);
        end;
    //end;
}

