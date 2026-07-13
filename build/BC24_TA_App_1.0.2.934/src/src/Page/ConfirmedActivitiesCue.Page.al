page 50394 "Confirmed Activities Cue"
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
                Caption = 'Confirmed Registration Dashboard';
                ShowCaption = true;
                Visible = true;
                field("Confirmed Female"; Confemales)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confemales field.';
                    trigger OnDrillDown()
                    begin
                        Recruits.Reset();
                        Recruits.SetRange(Gender, Recruits.Gender::Female);
                        Recruits.SetRange(Status, Recruits.Status::Confirmed);
                        Recruits.SetRange("Current Cohort", true);
                        if Recruits.Find('-') then begin
                        end;
                        ConfirmedPage.SetTableView(Recruits);
                        ConfirmedPage.Run();
                    end;
                }
                field("Confirmed Male"; ConfMales)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ConfMales field.';
                    trigger OnDrillDown()
                    begin
                        Recruits.Reset();
                        Recruits.SetRange(Gender, Recruits.Gender::Male);
                        Recruits.SetRange(Status, Recruits.Status::Confirmed);
                        Recruits.SetRange("Current Cohort", true);
                        if Recruits.Find('-') then begin
                        end;
                        ConfirmedPage.SetTableView(Recruits);
                        ConfirmedPage.Run();
                    end;
                }
                field("Confirm Disabled"; ConfDisability)
                {
                    Caption = 'Confirmeds PWD';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirmeds PWD field.';
                    trigger OnDrillDown()
                    begin
                        Recruits.Reset();
                        Recruits.SetRange("Is Disable", true);
                        Recruits.SetRange(Status, Recruits.Status::Confirmed);
                        Recruits.SetRange("Current Cohort", true);
                        if Recruits.Find('-') then begin
                        end;
                        ConfirmedPage.SetTableView(Recruits);
                        ConfirmedPage.Run();
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
        ConfMales := 0;
        Confemales := 0;
        ConfDisability := 0;

        Recruits.Reset();
        Recruits.SetRange(Gender, Recruits.Gender::Male);
        Recruits.SetRange(Status, Recruits.Status::Confirmed);
        Recruits.SetRange("Current Cohort", true);
        if Recruits.Find('-') then begin
            ConfMales := Recruits.Count();
        end;
        Recruits.Reset();
        Recruits.SetRange(Gender, Recruits.Gender::Female);
        Recruits.SetRange(Status, Recruits.Status::Confirmed);
        Recruits.SetRange("Current Cohort", true);
        if Recruits.Find('-') then begin
            Confemales := Recruits.Count();
        end;
        Recruits.Reset();
        Recruits.SetRange("Is Disable", true);
        Recruits.SetRange(Status, Recruits.Status::Confirmed);
        Recruits.SetRange("Current Cohort", true);
        if Recruits.Find('-') then begin
            ConfDisability := Recruits.Count();
        end;
    end;

    var
        Recruits: Record "Registration Form";
        ConfirmedPage: page "Registration List Confirmed";
        ConfMales: Integer;
        Confemales: Integer;
        ConfDisability: Integer;
}




