Page 50152 "Tickets ListPart"
{
    LinksAllowed = true;
    PageType = ListPart;
    SourceTable = Tickets;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Priority Level"; Rec."Priority Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Priority Level field.';
                }
                field("Date Raised"; Rec."Date Raised")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Raised field.';
                }
                field("Assigned To"; Rec."Assigned To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned To field.';
                }
                field("Served By"; Rec."Served By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Served By field.';
                }
                field(Resolution; Rec.Resolution)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resolution field.';
                }
                field(Workaround; Rec.Workaround)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Workaround field.';
                }
                field("Resolved By"; Rec."Resolved By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Resolved By field.';
                }
                field("Date Resolved"; Rec."Date Resolved")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Resolved field.';
                }
            }
        }
    }

    actions { }
}

