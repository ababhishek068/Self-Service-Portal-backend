Table 50723 "Contract"
{
    DrillDownPageId="Contracts List";

    fields
    {
        field(1; "Contract Reference No"; Code[10])
        {
            DataClassification = ToBeClassified;
            Editable = false;

            trigger OnValidate()
            begin
            end;
        }
        field(2; "Contract Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Simple,Complex,Framework Agreement';
            OptionMembers = " ",Simple,Complex,"Framework Agreement";
        }
        field(3; "Contractor No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Vendor."No.";
            trigger OnValidate()
            begin
                IF vend.GET("Contractor No.") THEN
                    "Contractor Name" := UPPERCASE(vend.Name);
            end;
        }
        field(4; "Contractor Name"; Text[30])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(5; "Effective Date"; Date)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                CLEAR("Expiry Date");
                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(6; "Expiry Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(7; "Contract Value"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "User ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                Dimval.RESET;
                Dimval.SETRANGE(Dimval."Global Dimension No.", 1);
                Dimval.SETRANGE(Dimval.Code, "Global Dimension 1 Code");
                IF Dimval.FIND('-') THEN
                    "Function Name" := Dimval.Name
            end;
        }
        field(10; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                Dimval.RESET;
                Dimval.SETRANGE(Dimval."Global Dimension No.", 2);
                Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 2 Code");
                IF Dimval.FIND('-') THEN
                    "Budget Center Name" := Dimval.Name
            end;
        }
        field(11; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the function in the database';
        }
        field(12; "Budget Center Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the budget center in the database';
        }
        field(13; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));

            trigger OnValidate()
            begin
                Dimval.RESET;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",3);
                Dimval.SETRANGE(Dimval.Code, "Shortcut Dimension 3 Code");
                IF Dimval.FIND('-') THEN
                    Dim3 := Dimval.Name
            end;
        }
        field(14; "Shortcut Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,2,4';
            Caption = 'Shortcut Dimension 4 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(4));

            trigger OnValidate()
            begin
                Dimval.Reset;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",4);
                Dimval.SetRange(Dimval.Code, "Shortcut Dimension 4 Code");
                if Dimval.Find('-') then
                    Dim4 := Dimval.Name
            end;
        }

        field(15; Dim3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(16; Dim4; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(17; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin



                TESTFIELD(Status, Status::Open);
                /*IF NOT UserMgt.CheckRespCenter(1, "Responsibility Center") THEN
                    ERROR(
                      Text001,
                      RespCenter.TABLECAPTION, UserMgt.GetPurchasesFilter);}*/

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
        field(18; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(19; Status; Option)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            OptionCaption = 'Open,Rejected,Pending Approval,Cancelled,Approved,Extended,Terminated,Legal';
            OptionMembers = Open,Rejected,"Pending Approval",Cancelled,Approved,Extended,Terminated,Legal;
        }
        field(20; "Requested By"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "User Setup"."User ID";

            trigger OnValidate()
            begin
                /*
               "Request Description":='';

               "Request Description":='Requested by ' + "Requested By";
                  */

            end;
        }
        field(21; "Remarks Section"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(22; "Subject Matter"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(23; "Contract Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Active,Expired,Cancelled,Approved';
            OptionMembers = " ",Active,Expired,Cancelled,Approved;
        }
        field(24; "File Number"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(25; "Contract No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(26; Duration; DateFormula)
        {
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                TESTFIELD("Effective Date");
                CLEAR("Expiry Date");


                "Expiry Date" := CALCDATE(Duration, "Effective Date");
            end;
        }
        field(27; Active; Boolean)
        {
            DataClassification = ToBeClassified;
            Editable=true;
        }
        field(28; "Milestone Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(29; "Milestone Balance"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Paid Milestone"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(31; "Unpaid Milestone"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(32; "Procurement WorkPlan"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Workplan."Workplan Code." WHERE(Blocked = FILTER('No'));
        }
        field(33; "Worplan Activity"; Code[30])
        {
            DataClassification = ToBeClassified;
            TableRelation = IF ("Procurement WorkPlan" = FILTER('ADMIN')) "Workplan Activities"."Activity Code" WHERE("Account Type" = FILTER('Posting'))
            ELSE
            IF ("Procurement WorkPlan" = FILTER('ICT')) "Workplan Activities"."Activity Code" WHERE("Account Type" = FILTER('Posting'));
        }
        field(34; "Termination Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(134; "Termination Remarks"; Text[200])
        {
            DataClassification = ToBeClassified;
        }
        field(35; "Board Approved"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(36; "Procurement Method"; code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Procurement Methods".code;
        }
        field(37; "Recommendation"; option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Inhouse Counsel","Office of the AG","External Counsel";
        }
        // field(38; "Tender No."; Code[30])
        // {
        //     DataClassification = ToBeClassified;
        //     TableRelation = "Tender Plan Header"."No.";
        // }
        field(39; "Email 1"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Email 2"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(41; "Email 3"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(42; "Has CIT"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50;"Tender No";Code[20])
        {
            TableRelation="Purchase Quote Header"."No.";
            trigger OnValidate()
            var
            tenderlist: Record "Purchase Quote Header";
            begin
                 tenderlist.Reset();
                 tenderlist.SetRange(tenderlist."No.","Tender No");
                 if tenderlist.FindFirst() then begin            
               
                    "Tender name":=tenderlist."Request Description";
                end;

            end;
        }
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
            TableRelation="Payments Header"."No." where(Posted=const(true));
        }
        field(50002; "Installment Amount"; Decimal)
        {
            Caption = 'Installment Amount';
            DataClassification = CustomerContent;
        }


        field(50003; "Invoice Period"; Enum "Service Contract Header Invoice Period")
        {
            Caption = 'Invoice Period';
            trigger OnValidate()
            begin
                TestField("Posting Date");
                TestField("Last payment Date");
                case "Invoice Period" of
                    "Invoice Period"::Month:
                        "Next payment Date" := CalcDate('<1M>', "Last payment Date");
                    "Invoice Period"::"Two Months":
                        "Next Payment Date" := CalcDate('<2M>', "Last payment Date");
                    "Invoice Period"::Quarter:
                        "Next Payment Date" := CalcDate('<3M>', "Last payment Date");
                    "Invoice Period"::"Half Year":
                        "Next Payment Date" := CalcDate('<6M>', "Last payment Date");
                    "Invoice Period"::Year:
                        "Next Payment Date" := CalcDate('<12M>', "Last payment Date");
                    "Invoice Period"::None:
                        if Prepaid then
                            "Next Payment Date" := 0D;
                end;
                if not Prepaid and ("Next Payment Date" <> 0D) then
                    "Next Payment Date" := CalcDate('<CM>', "Next Payment Date");

                // if ("Last Invoice Date" <> 0D) and ("Last Invoice Date" <> xRec."Last Invoice Date") then
                //     if Prepaid then
                //         Validate("Last Invoice Period End", "Next Invoice Period End")
                //     else
                //         Validate("Last Invoice Period End", "Last Invoice Date");

                Validate("Next Payment Date");
            end;
            

        
        }
        field(50004; "Last payment Date"; Date)
        {
            Caption = 'Last Payment Date';
            Editable = false;

            
        }
        field(50005; "Next Payment Date"; Date)
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

        field(50012; "Next Payment Period Start"; Date)
        {
            Caption = 'Next Invoice Period Start';
            Editable = false;
        }
        field(50013; "Next Payment Period End"; Date)
        {
            Caption = 'Next Invoice Period End';
            Editable = false;
        }
        field(45; Prepaid; Boolean)
        {
            Caption = 'Prepaid';
            Editable=false;
        }
        field(46;"Posting Date";Date){
            Editable=true;
            Caption='Posting Date';
            
        }
        field(48;"Payment Delay";Integer){
            caption='Payment Delay(Days)';
        }
        field(47;"Annual Maintence Contract?";Boolean)
        {
           

        }
        field(49;"Contract Name";text[250]){
            trigger OnValidate()
            begin
                TestField("Tender No");
            end;

        }
        field(60;"Tender name";Text[250]){}
        field(61;"Perfomance Bond";Boolean){
            Editable=false;
        }
        field(62;"Perfomance Bond Amount"; Decimal){
            trigger OnValidate()
            begin
                TestField("Contract Value");
                if (("Perfomance Bond Amount"/"Contract Value")*100)<>10 then begin
                    Error('Permonce Bond must be 10 Percent of the Contract Value');


                end;
            end;
        }
        field(63;"Perfomance Bond Start Date";Date){
            trigger OnValidate()
            begin
                if "Perfomance Bond Start Date"<>0D then 
                Validate("PB Period");
            end;
        }
        field (64;"PB Period";DateFormula){
            trigger OnValidate()
            begin
                TESTFIELD("Perfomance Bond Start Date");
                CLEAR("Perfomance Bond End Date");


                "Perfomance Bond End Date" := CALCDATE("PB Period", "Perfomance Bond Start Date");
                if "Perfomance Bond End Date"<>0D then begin
                    "Perfomance Bond":=true;
                end;
            end;
        }
        field(65;"PB Issue Date";date){}
        field(66;"Perfomance Bond End Date";Date){}
        field(67;"PB Bank Name";Text[100]){}
        field(68;"Perfomance Bond Ref No";code[20]){}
        field(69;"PB Confirmed?";Boolean){
            Editable=false;
        }
        field(70;"PB Confirmation Ref";Code[20]){
            trigger OnValidate()
            begin
                if "PB Confirmation Ref"<>'' then begin
                    "PB Confirmed?":=true;
                end;
            end;
        }
        field(71;"PB Confirmation Date";date){}
        field(72;"PB Extended?";Boolean){
            Editable=false;
        }
        field(73;"PB Extension Start date";date){}
        field(74;"PB Extension End date";date){
            trigger OnValidate()
            begin
                TestField("PB Extension Start date");
                if "PB Extension Start date"< "PB Extension End date" then begin
                    "PB Extended?":=true;

                end else begin
                    Error('Start Date must be earlier than End Date');
                end;
            end;
        }
        field(75;"PB Notification of Expiry done?";Boolean){
            Editable=false;

        }
        field(76;"PB Date Notified";Date){
            trigger OnValidate()
            begin
                if "PB Date Notified"<>0D  then begin
                    "PB Notification of Expiry done?":=true;


                end;
            end;
        }
        field(77;"PB Notification Ref";code[20]){
            trigger OnValidate()
            begin
                TestField("PB Date Notified");
            end;
        }

        //Guarantee

        field(81;"Payment Guarantee?";Boolean){
            Editable=false;
        }
        field(82;"Payment Guarantee Amount"; Decimal){
            trigger OnValidate()
            begin
                TestField("Contract Value");
                if "Payment Guarantee Amount"<="Contract Value" then begin

                end else if "Payment Guarantee Amount">"Contract Value" then begin
                    Error('Payment Guarantee cannot be greater than contract value');
                end;
                if "Contract Value"<>0 then begin
                    "% of Contract Value":=("Payment Guarantee Amount"/"Contract Value")*100;
                end;
            end;
        }
        field(83;"PG  Start Date";Date){}
        field (84;"PG Period";DateFormula){
            trigger OnValidate()
            begin
                TESTFIELD("PG  Start Date");
                CLEAR("PG End Date");


                "PG End Date" := CALCDATE("PG Period", "PG  Start Date");
                Validate("PG End Date");
            end;
        }
        field(85;"PG Issue Date";date){}
        field(86;"PG End Date";Date){
            Caption='Payment Guarantee Expiry Date';
            Editable=false;
            trigger OnValidate()
            begin
                if "PG End Date"<>0D then begin
                    "Payment Guarantee?":=true;
                end;
            end;
        }
        field(87;"PG Bank Name";Text[100]){}
        field(88;"PG Ref No";code[20]){}
        field(89;"PG Confirmed?";Boolean){
            Editable=false;
        }
        field(90;"PG Confirmation Ref";Code[20]){}
        field(91;"PG Confirmation Date";date){
            trigger OnValidate()
            begin
                "PG Confirmed?":=true;
            end;
        }
        field(92;"PG Extended?";Boolean){
            Editable=false;
        }
        field(93;"PG Extension Start date";date){
            trigger OnValidate()
            begin
                TestField("PG Extension Start date");
                if "PG Extension Start date">"PG End Date" then begin


                end else begin 
                    Error('You cannot extend before expiry before end date');
                end;
            end;
        }
        field(94;"PG Extension End date";date){
            trigger OnValidate()
            begin
                TestField("PG Extension Start date");
                if "PG Extension End date">"PG Extension Start date" then begin
                    "PG Extended?":=true;

                end else begin
                    Error('End Date cannot be before Start Date');
                end;
            end;
        }
        field(95;"PG Notification of Expiry done?";Boolean){
            Editable=false;
        }
        field(96;"PG Date Notified";Date){
            trigger OnValidate()
            begin
                if "PG Date Notified"<>0D then begin
                    "PG Notification of Expiry done?":=true;
                end;
            end;
        }
        field(97;"PG Notification Ref";code[20]){
            trigger OnValidate()
            begin
                TestField("PG Date Notified");
            end;
        }
        field(98;"% of Contract Value";Decimal){
            Editable=false;
        }
        
        
    


    }

    keys
    {
        key(Key1; "Contract Reference No") { }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if "Contract Reference No" = '' then begin
            GenLedgerSetup.Get();
            GenLedgerSetup.TestField(GenLedgerSetup."Contract No.");
            "Contract Reference No" :=  NoSeriesMgt.GetNextNo(GenLedgerSetup."Contract No.",Today, true);
        end;

        CurrentYear := Format(Date2dmy(Today, 3));


        // "Contract No." := CurrentYear + '/' + IncStr(CurrentYear) + "Contract Reference No";
    end;

    var

        NoSeriesMgt: Codeunit "No. Series";
        GenLedgerSetup: Record "Purchases & Payables Setup";

        Dimval: Record "Dimension Value";
        vend: Record Vendor;
        CurrentYear: Code[20];

}

