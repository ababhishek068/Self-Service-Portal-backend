pageextension 52100 "Portal Exit HR Role Center" extends "Human Resource Role Centre"
{
    actions
    {
        addlast(Sections)
        {
            group("Employee Exit")
            {
                Caption = 'Employee Exit';

                action("Employee Exit Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Exit Requests';
                    RunObject = page "Portal Employee Exit Requests";
                }
                action("Transfer Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Transfer Requests';
                    RunObject = page "Portal Employee Exit Requests";
                    RunPageView = where("Request Type" = const(Transfer));
                }
                action("Employee Transfer Setup")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Transfer Setup';
                    RunObject = page "Portal Employee Transfer Setup";
                }
                action("Resignation Applications")
                {
                    ApplicationArea = All;
                    Caption = 'Resignation Applications';
                    RunObject = page "Portal Employee Exit Requests";
                    RunPageView = where("Request Type" = const(Resignation));
                }
                action("Employee Exit Forms")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Exit Forms';
                    RunObject = page "Portal Employee Exit Requests";
                    RunPageView = where("Request Type" = const(ExitInterview));
                }
            }
        }
    }
}
