Page 50352 "Project Team"
{
    PageType = List;
    SourceTable = "Project Team";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Team Member"; Rec."Team Member")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Team Member field.';
                }
                field("Team Name"; Rec."Team Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Team Name field.';
                }
                field(Client; Rec.Client)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Client field.';
                }
                field("Project Status"; Rec."Project Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Project Status field.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Test eMAIL")
            {
                ApplicationArea = Basic;
                ToolTip = 'Executes the Test eMAIL action.';

                trigger OnAction()
                begin
                    Compinfo.Get();
                    SMTPMail.Create('cknjuguna@gmail.com', COMPANYNAME, 'TEST', true);
                    SendEmail.Send(SMTPMail, Enum::"Email Scenario"::Default);
                end;
            }
        }
    }

    var
        Compinfo: Record "Company Information";
        SMTPMail: Codeunit "Email Message";
        SendEmail: codeunit email;

}

