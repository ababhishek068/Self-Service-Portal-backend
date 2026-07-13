Page 50150 "Tickets List"
{
    CardPageID = "Tickets Card";
    PageType = List;
    SourceTable = Tickets;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Ticket Number"; Rec."Ticket Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Ticket Number field.';
                }
                field(Customer; Rec.Customer)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Customer field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Status field.';
                }
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
                field("Assigned To"; Rec."Assigned To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned To field.';
                }
                field("Date Raised"; Rec."Date Raised")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Raised field.';
                }
                field("Served By"; Rec."Served By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Served By field.';
                }
                field("Priority Level"; Rec."Priority Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Priority Level field.';
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
            }
        }
    }

    actions { }
}

