page 51343 "Registration Activities Cue"
{
    PageType = CardPart;
    SourceTable = "HR Activities Cue";
    ApplicationArea = All;

    layout
    {
        area(content)
        {

            cuegroup(RegActivities)
            {
                Caption = 'Registration Dashboard';
                ShowCaption = true;
                Visible = true;
                field("Registered Female"; RegFemales)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RegFemales field.';
                    trigger OnDrillDown()
                    begin
                        Recruits.Reset();
                        Recruits.SetRange(Gender, Recruits.Gender::Female);
                        Recruits.SetRange(Status, Recruits.Status::Pending);
                        Recruits.SetRange("Current Cohort", true);
                        if Recruits.Find('-') then begin
                        end;
                        RecruitPage.SetTableView(Recruits);
                        RecruitPage.Run();
                    end;
                }
                field("Registered Male"; RegMales)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the RegMales field.';
                    trigger OnDrillDown()
                    begin
                        Recruits.Reset();
                        Recruits.SetRange(Gender, Recruits.Gender::Male);
                        Recruits.SetRange(Status, Recruits.Status::Pending);
                        Recruits.SetRange("Current Cohort", true);
                        if Recruits.Find('-') then begin
                        end;
                        RecruitPage.SetTableView(Recruits);
                        RecruitPage.Run();
                    end;
                }
                field("Registered Disabled"; RegDisability)
                {
                    Caption = 'Registered PWD';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Registered PWD field.';
                    trigger OnDrillDown()
                    begin
                        Recruits.Reset();
                        Recruits.SetRange("Is Disable", true);
                        Recruits.SetRange(Status, Recruits.Status::Pending);
                        Recruits.SetRange("Current Cohort", true);
                        if Recruits.Find('-') then begin
                        end;
                        RecruitPage.SetTableView(Recruits);
                        RecruitPage.Run();
                    end;
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.RESET;
        IF NOT Rec.GET THEN BEGIN
            Rec.INIT;
            Rec.INSERT;
        END;
    end;

    trigger OnAfterGetRecord()
    begin
        RegMales := 0;
        RegFemales := 0;
        RegDisability := 0;

        Recruits.Reset();
        Recruits.SetRange(Gender, Recruits.Gender::Male);
        Recruits.SetRange(Status, Recruits.Status::Pending);
        Recruits.SetRange("Current Cohort", true);
        if Recruits.Find('-') then begin
            RegMales := Recruits.Count();
        end;
        Recruits.Reset();
        Recruits.SetRange(Gender, Recruits.Gender::Female);
        Recruits.SetRange(Status, Recruits.Status::Pending);
        Recruits.SetRange("Current Cohort", true);
        if Recruits.Find('-') then begin
            RegFemales := Recruits.Count();
        end;
        Recruits.Reset();
        Recruits.SetRange("Is Disable", true);
        Recruits.SetRange(Status, Recruits.Status::Pending);
        Recruits.SetRange("Current Cohort", true);
        if Recruits.Find('-') then begin
            RegDisability := Recruits.Count();
        end;
    end;

    var
        Recruits: Record "Registration Form";
        RecruitPage: page "Registration List";
        RegMales: Integer;
        RegFemales: Integer;
        RegDisability: Integer;
}




