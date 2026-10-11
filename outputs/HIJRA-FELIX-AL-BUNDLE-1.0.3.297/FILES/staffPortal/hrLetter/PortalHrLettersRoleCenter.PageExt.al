pageextension 52147 "Portal HR Letters Role Center" extends "Human Resource Role Centre"
{
    actions
    {
        addlast(Sections)
        {
            group("HR Service Letters")
            {
                Caption = 'HR Service Letters';

                action("Portal HR Letter Requests")
                {
                    ApplicationArea = All;
                    Caption = 'Portal HR Letter Requests';
                    RunObject = page "Portal HR Letter Requests";
                }
                action("Submitted HR Letters")
                {
                    ApplicationArea = All;
                    Caption = 'Submitted HR Letters';
                    RunObject = page "Portal HR Letter Requests";
                    RunPageView = where(Status = const(Submitted));
                }
                action("In Progress HR Letters")
                {
                    ApplicationArea = All;
                    Caption = 'In Progress HR Letters';
                    RunObject = page "Portal HR Letter Requests";
                    RunPageView = where(Status = const(InProgress));
                }
                action("Ready for Collection HR Letters")
                {
                    ApplicationArea = All;
                    Caption = 'Ready for Collection';
                    RunObject = page "Portal HR Letter Requests";
                    RunPageView = where(Status = const(ReadyForCollection));
                }
            }
        }
    }
}
