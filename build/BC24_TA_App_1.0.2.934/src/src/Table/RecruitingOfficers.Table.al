Table 50113 "Recruiting Officers"
{
    fields
    {
        field(1; "No"; Code[30])
        {
            TableRelation = "HR-Employee"."No." where(Status = filter(Active));
            trigger OnValidate()
            var
                HREmp: Record "HR-Employee";
            begin
                if HREmp.GET(No) then Name := HREmp."First Name" + ' ' + HREmp."Middle Name" + ' ' + HREmp."Last Name";
            end;
        }
        field(2; Name; Text[150]) { }
        field(3; "Recruitment Center"; Code[20])
        {
            TableRelation = "Recruitment Centers".Code;
            trigger OnValidate()
            var
                RecrOfficerHist: Record "Recruiting Officers History";
            begin
                TestField(No);
                TestField(Corhot);
                RecrOfficerHist.Reset();
                RecrOfficerHist.SetRange(No, No);
                RecrOfficerHist.SetRange("Recruitment Center", "Recruitment Center");
                RecrOfficerHist.SetRange(Corhot, Corhot);
                if not RecrOfficerHist.Find('-') then begin
                    RecrOfficerHist.Init();
                    RecrOfficerHist.No := No;
                    RecrOfficerHist.Validate(No);
                    RecrOfficerHist."Recruitment Center" := "Recruitment Center";
                    RecrOfficerHist."Recruitment Date" := "Recruitment Date";
                    RecrOfficerHist.Corhot := Corhot;
                    RecrOfficerHist."Assigned By" := Database.UserId;
                    RecrOfficerHist."Date Assigned" := Today;
                    RecrOfficerHist.Insert();
                end;
            end;
        }
        field(4; Corhot; Code[20])
        {
            TableRelation = Intake.Code where(Current = filter(true));
        }
        field(6; "Recruitment Date"; Date)
        {
            trigger OnValidate()
            var
                RecrOfficerHist: Record "Recruiting Officers History";
                RecruitOfficer: Record "Recruiting Officers";
            begin
                TestField(No);
                TestField(Corhot);
                RecrOfficerHist.Reset();
                RecrOfficerHist.SetRange(No, No);
                RecrOfficerHist.SetRange("Recruitment Center", "Recruitment Center");
                RecrOfficerHist.SetRange(Corhot, Corhot);
                if RecrOfficerHist.Find('-') then begin
                    RecrOfficerHist."Recruitment Date" := "Recruitment Date";
                    RecrOfficerHist."Assigned By" := Database.UserId;
                    RecrOfficerHist."Date Assigned" := Today;
                    RecrOfficerHist.Modify();
                end;

                RecruitOfficer.Reset();
                RecruitOfficer.SetRange(No, No);
                RecruitOfficer.SetRange(Corhot, Corhot);
                RecruitOfficer.SetRange("Recruitment Date", "Recruitment Date");
                if RecruitOfficer.Find('-') then Error('This officer is already assigned for today at center ' + RecruitOfficer."Recruitment Center");
            end;
        }
        field(8; "Assigned By"; Code[50])
        {
            TableRelation = "User Setup"."User ID";
            Editable = false;
        }
        field(9; "Date Assigned"; Date)
        {
            Editable = false;
        }
        field(10; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(11; "Type"; Option)
        {
            OptionMembers = Recruit,Confirm;
        }
        field(12; "Paramiliraty Academy"; Code[20])
        {
            TableRelation = "Paramilitary Academy".Code;
        }
        field(13; "From Date"; Date) { }
        field(14; "To Date"; Date) { }
    }

    keys
    {
        key(Key1; No, Corhot, "Recruitment Center", "Line No", Type)
        {
            Clustered = true;
        }
    }

    fieldgroups { }
    trigger OnInsert()
    var
        RecrOff: Record "Recruiting Officers";
    begin
        RecrOff.Reset();
        RecrOff.SetRange(No, No);
        RecrOff.SetRange(Corhot, Corhot);
        RecrOff.SetRange("Recruitment Center", "Recruitment Center");
        RecrOff.SetRange("Recruitment Date", "Recruitment Date");
        if RecrOff.Find('-') then Error('You have already been assigned this entry');

        "Assigned By" := Database.UserId;
        "Date Assigned" := Today;
    end;

    trigger OnModify()
    begin
        if (("Recruitment Date" < Today) and (Type = Type::Recruit)) then Error('You cannot ammend this entry. The assigned recruitment date has already passed. You can either enter a new entry');
    end;
}

