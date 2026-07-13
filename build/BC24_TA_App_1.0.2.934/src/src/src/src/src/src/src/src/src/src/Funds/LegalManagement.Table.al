Table 50418 "Legal Management"
{

    fields
    {
        field(1; No; Code[20])
        {

            trigger OnValidate()
            begin
                /*
                IF "Visitor Number" <> xRec."Visitor Number" THEN BEGIN
                  GenSetu.GET;
                  NoSeriesMgt.TestManual(GenSetu."Visitor Number");
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(2; "Visitor Name"; Text[150]) { }
        field(3; "ID Number"; Code[10]) { }
        field(4; "Phone Number"; Code[10]) { }
        field(5; "Car Reg. Number"; Code[8])
        {
            //  TableRelation = if ("Visitor Category" = const(Employee)) "HR Employee Vehicle"."Vehicle Reg No" where("Employee No" = field("Visitor Number"));
        }
        field(6; "Person To See"; Text[150]) { }
        field(7; "Purpose of Visit"; Text[150]) { }
        field(8; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
        }
        field(9; "Visitor Pass No."; Code[10]) { }
        field(10; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Posted,Cancelled,Rejected';
            OptionMembers = New,PendingApproval,Approved,Posted,Cancelled,Rejected;
        }
        field(100; "Progress Status"; Option)
        {
            OptionCaption = 'New,Ongoing,Closed';
            OptionMembers = New,Ongoing,Closed;
        }
        field(11; "Initiated By"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(12; "Initiated By Time"; Time) { }
        field(13; "Cleared By"; Code[20])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(23; "Assigned to"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
        }
        field(14; "Cleared By Time"; Time) { }
        field(15; "No. Series"; Code[20]) { }
        field(16; "Created Date"; Date) { }
        field(17; "Created Time"; Time) { }
        field(18; "Initiated Date"; Date) { }
        field(19; "Cleared Date"; Date) { }
        field(20; "Visitor Category"; Option)
        {
            OptionCaption = ' ,Guidance,Opinion,Review';
            OptionMembers = " ",Guidance,Opinion,Review;
        }
        field(21; "Visitor Number"; Code[20]) { }
        field(50000; "Visitor Car Reg Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; Comments; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Feedback; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; Opinions; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50133; Attendance; Text[1000])
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Hearing Date"; date)
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Litigation Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Created,Ongoing,Under Litigation,Approved,Out Of Court Settlememt';
            OptionMembers = Created,Ongoing,UnderLitigation,Approved,OutOfCourtSettlememt;
        }
        field(50124; "Resolution Type"; Option)
        {
            caption = 'Recommendation';

            DataClassification = ToBeClassified;
            OptionCaption = 'In house Counsel, Office of the AG, External Counsel';
            OptionMembers = "In house Counsel","Office of the AG","External Counsel";
        }
        field(50005; "Concerned Department Notified"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Documents Attached?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Request date"; Date)
        {
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Required Date" := "Request date" + 10;
            end;
        }
        field(50008; "Required Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference to the first global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                Dimval.Reset;
                Dimval.SetRange(Dimval."Global Dimension No.", 1);
                Dimval.SetRange(Dimval.Code, "Global Dimension 1 Code");
                if Dimval.Find('-') then
                    "Function Name" := Dimval.Name
            end;
        }
        field(50010; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the second global dimension in the database';
            NotBlank = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                Dimval.Reset;
                Dimval.SetRange(Dimval."Global Dimension No.", 2);
                Dimval.SetRange(Dimval.Code, "Shortcut Dimension 2 Code");
                if Dimval.Find('-') then
                    "Budget Center Name" := Dimval.Name
            end;
        }
        field(50011; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the function in the database';
        }
        field(50012; "Budget Center Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the budget center in the database';
        }
        field(50013; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,2,3';
            Caption = 'Shortcut Dimension 3 Code';
            DataClassification = ToBeClassified;
            Description = 'Stores the reference of the Third global dimension in the database';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(3));

            trigger OnValidate()
            begin
                Dimval.Reset;
                //Dimval.SETRANGE(Dimval."Global Dimension No.",3);
                Dimval.SetRange(Dimval.Code, "Shortcut Dimension 3 Code");
                if Dimval.Find('-') then
                    Dim3 := Dimval.Name
            end;
        }
        field(50014; "Shortcut Dimension 4 Code"; Code[20])
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
        field(50015; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            DataClassification = ToBeClassified;
            TableRelation = "Responsibility Center BR";

            trigger OnValidate()
            begin

                TestField(Status, Status::New);
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
        field(50016; "Issue Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50017; "Department Name"; Text[250])
        {
            CalcFormula = lookup("Dimension Value".Name where("Dimension Code" = filter('DEPARTMENT'),
                                                               Code = field("Shortcut Dimension 2 Code")));
            FieldClass = FlowField;
        }
        field(50018; "Employee No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50019; Dim3; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50020; Dim4; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50021; "Meeting Held?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50022; "Meeting Schedule Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50023; "Litigation Cleared"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50024; "Case Details"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50028; "Court Negotiations"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50029; "Settlement Out of Court"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50030; "Settlement Details"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50031; "Next Court Schedule"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50132; "Next Hearing Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50032; "Settlement Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50033; "Court Settlement Details"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(50034; "Proceedings Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50035; "Send to Litigation"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Type"; Option)
        {
            OptionMembers = Legal,Letigation,ADR;
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        if No = '' then begin
            GenSetu.Get;
            GenSetu.TestField(GenSetu."Legal Nos");
            GenSetu.TestField(GenSetu."Letigation Nos");
            //   if "Send to Litigation" = false then
            if Type = Type::Legal then
                No:=NoSeriesMgt.GetNextNo(GenSetu."Legal Nos",  0D, true)
            else
                No:=NoSeriesMgt.GetNextNo(GenSetu."Letigation Nos",  0D, true)

        end;

        Status := Status::New;
        "Request date" := Today;
        Validate("Request date");
        "Created Time" := Time;
        "Created Date" := Today;
    end;

    var
        GenSetu: Record "Security Setups";
        NoSeriesMgt: Codeunit "No. Series";
        RespCenter: Record "Responsibility Center BR";
        UserMgt: Codeunit "User Setup Management BR";
        Dimval: Record "Dimension Value";
        Text001: label 'Your identification is set up to process from %1 %2 only.';
}

