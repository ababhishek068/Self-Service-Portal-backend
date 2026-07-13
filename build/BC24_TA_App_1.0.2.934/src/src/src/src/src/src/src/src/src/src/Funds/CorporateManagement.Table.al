Table 50396 "Corporate Management"
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
        field(5; "Car Reg. Number"; Code[8]) { }
        field(6; "Person To See"; Text[150]) { }
        field(7; "Purpose of Visit"; Text[150]) { }
        field(8; Department; Code[20])
        {
            TableRelation = "Dimension Value".Code where("Dimension Code" = filter('DEPARTMENT'));
        }
        field(9; "Visitor Pass No."; Code[10]) { }
        field(10; Status; Option)
        {
            OptionCaption = 'New,Arrived,Entered,Received,Cleared,Approved,Posted,Cancelled,Open,Released';
            OptionMembers = New,Arrived,Entered,Received,Cleared,Approved,Posted,Cancelled,Open,Released;
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
        field(14; "Cleared By Time"; Time) { }
        field(15; "No. Series"; Code[20]) { }
        field(16; "Created Date"; Date) { }
        field(17; "Created Time"; Time) { }
        field(18; "Initiated Date"; Date) { }
        field(19; "Cleared Date"; Date) { }
        field(20; "Visitor Category"; Option)
        {
            OptionCaption = 'Employee,High School,Primary,KABU ,Student';
            OptionMembers = Employee,"High School",Primary,"KABU ",Student;
        }
        field(21; "Requisitioning Officer"; Code[20])
        {
            TableRelation = if ("Visitor Category" = const(Student)) Customer."No." where("Customer Posting Group" = const('STUDENT'))
            else
            if ("Visitor Category" = const(Employee)) "HR-Employee"."No." where(Status = const(Active));

            trigger OnValidate()
            begin
                if Cust.Get("Requisitioning Officer") then
                    "Visitor Name" := Cust.Name;
                if Emp.Get("Requisitioning Officer") then
                    "Visitor Name" := Emp."First Name" + ' ' + Emp."Middle Name" + ' ' + Emp."Last Name";
            end;
        }
        field(50001; "Reason(s)"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50002; Feedback; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50003; Opinions; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50007; "Request date"; Date)
        {
            DataClassification = ToBeClassified;
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



        }
        field(50011; "Function Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Description = 'Stores the name of the function in the database';
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
        field(50035; "Nature of Meeting"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50036; "Number  Of Participants"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(50037; "Estimated Duration Of Meeting"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50038; "Room Availability"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50039; Reason; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50040; Date; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50041; Designation; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50042; "Recommend Stnt ID Replacement"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50043; "Permission Granted"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50044; "Reasons For Replacement?"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50045; SDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50046; LDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50047; "LID HELD?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50048; SIDHELD; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50049; Type; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ',Student,Department,Staff';
            OptionMembers = ,Student,Department,Staff;
        }
        field(50050; "Student Picture"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(50051; Complaints; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50052; "Action Taken?"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50053; "Action Recommended"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50054; "Corrective Action"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50055; "Email Addresss"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50056; "Received By"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(50057; "Customer Name"; Text[30])
        {
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
            GenSetu.TestField(GenSetu."Corporate No.");
            No:=NoSeriesMgt.GetNextNo(GenSetu."Corporate No.",  0D, true);
        end;

        Status := Status::Open;
        "Request date" := Today;
        "Created Time" := Time;
        "Created Date" := Today;
    end;

    var
        GenSetu: Record "Security Setups";
        Emp: Record "HR-Employee";
        Cust: Record Customer;
        NoSeriesMgt: Codeunit "No. Series";
        Dimval: Record "Dimension Value";
}

