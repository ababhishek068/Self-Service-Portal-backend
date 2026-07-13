Table 50753 "Sec-Visitor Management"
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
            TableRelation = if ("Visitor Category" = const(Employee)) "HR Employee Vehicle"."Vehicle Reg No" where("Employee No" = field("Visitor Number"));
        }
        field(6; "Person To See"; Code[20])
        {
            TableRelation = "HR-Employee"."No.";
            trigger OnValidate()
            begin
                if Emp.Get("Person To See") then
                    "Person To See Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
            end;
        }
        field(7; "Purpose of Visit"; Text[150]) { }
        field(8; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(2));
        }
        field(9; "Visitor Pass No."; Code[10]) { }
        field(10; Status; Option)
        {
            OptionCaption = 'Arrived,Entered,Received,Cleared';
            OptionMembers = Arrived,Entered,Received,Cleared;
        }
        field(11; "Initiated By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            trigger OnValidate()
            begin
                Emp.Reset();
                Emp.SetRange("User ID", "Initiated By");
                if Emp.Find('-') then
                    Station := Emp."Global Dimension 1 Code"
                /* else
                    Error('Your Station has not been set. Contact HR'); */
            end;
        }
        field(12; "Initiated By Time"; Time) { }
        field(13; "Cleared By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(14; "Cleared By Time"; Time) { }
        field(15; "No. Series"; Code[20]) { }
        field(16; "Created Date"; Date) { }
        field(17; "Created Time"; Time) { }
        field(18; "Initiated Date"; Date) { }
        field(19; "Cleared Date"; Date) { }
        field(20; "Visitor Category"; Option)
        {
            OptionCaption = ' ,Student,Employee,Supplier,Customer,Other';
            OptionMembers = " ",Student,Employee,"Supplier",Customer,Other;
        }
        field(21; "Visitor Number"; Code[20])
        {
            TableRelation = if ("Visitor Category" = const(Student)) Customer."No." where("Customer Posting Group" = const('STUDENT'))
            else
            if ("Visitor Category" = const(Employee)) "HR-Employee"."No." where(Status = const(Active));

            trigger OnValidate()
            begin
                if Cust.Get("Visitor Number") then
                    "Visitor Name" := Cust.Name;
                if Emp.Get("Visitor Number") then
                    "Visitor Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
            end;
        }
        field(50000; "Visitor Car Reg Number"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(50001; "Action Recommended"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; "Action Taken"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50003; "Incident Details"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50004; "Incident Witness"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50005; "Incident Reported"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50006; "Visit No."; Code[20])
        {
            TableRelation = "Sec-Visitor Management".No where("Incident Reported" = filter(false));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                VisitorMGT: Record "Sec-Visitor Management";
            begin
                VisitorMGT.Reset();
                VisitorMGT.SetRange(No, "Visit No.");
                if VisitorMGT.Find('-') then begin
                    "Visitor Category" := VisitorMGT."Visitor Category";
                    "Visitor Name" := VisitorMGT."Visitor Name";
                    "Visitor Number" := VisitorMGT."Visitor Number";
                    "Person To See" := VisitorMGT."Person To See";
                    "Person To See Name" := VisitorMGT."Person To See Name";
                    "Purpose of Visit" := VisitorMGT."Purpose of Visit";
                    Department := VisitorMGT.Department;
                    Station := VisitorMGT.Station;
                    "ID Number" := VisitorMGT."ID Number";
                    "Phone Number" := VisitorMGT."Phone Number";
                    "Visitor Pass No." := VisitorMGT."Visitor Pass No.";
                    "Visitor Car Reg Number" := VisitorMGT."Visitor Car Reg Number";
                    "Car Reg. Number" := VisitorMGT."Car Reg. Number";
                    "Initiated By" := UserId;
                    "Initiated Date" := Today;
                    "Initiated By Time" := Time;
                end;
            end;
        }
        field(50007; "Incident Category"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Theft,Injury,Death,Car Accidents,Maritime Accidents,Others';
            OptionMembers = " ",Theft,Injury,Death,"Car Accidents","Maritime Accidents",Others;
        }
        field(50008; "Witness Contacts"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Witness ID"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(50010; Station; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Global Dimension No." = filter(1));
        }
        field(50011; "Person To See Name"; Code[150])
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Vessel Reg. No"; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Incident Description"; Code[500])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No, "Visit No.")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnInsert()
    begin
        /* Emp.Reset();
        Emp.SetRange("User ID", UserId);
        if not Emp.Find('-') then
            Error('Your Station has not been set. Contact HR'); */

        // if No = '' then begin
        //     GenSetu.Get;
        //     GenSetu.TestField(GenSetu."Visitors Nos");
        //     NoSeriesMgt.GetNextNo(GenSetu."Visitors Nos", xRec."No. Series", 0D, No, "No. Series");
        // end;
        Status := Status::Arrived;
        "Created Date" := Today;
        "Created Time" := Time;
        "Initiated Date" := Today;
        "Initiated By Time" := Time;
        "Initiated By" := UserId;
        Validate("Initiated By");
    end;

    var
        Emp: Record "HR-Employee";
        Cust: Record Customer;
}

