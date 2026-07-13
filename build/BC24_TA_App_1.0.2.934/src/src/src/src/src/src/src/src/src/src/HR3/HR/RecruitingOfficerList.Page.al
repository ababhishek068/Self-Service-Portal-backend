
Page 50562 "Recruiting Officer List"
{
    PageType = List;
    SourceTable = "Recruiting Officers";
    SourceTableView = where(Type = filter(Recruit));
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the No field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Corhot; Rec.Corhot)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Corhot field.';
                }
                field("Recruitment Center"; Rec."Recruitment Center")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recruitment Center field.';
                }
                field("Recruitment Date"; Rec."Recruitment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Recruitment Date field.';
                }
                field("Assigned By"; Rec."Assigned By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Assigned By field.';
                }
                field("Date Assigned"; Rec."Date Assigned")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Assigned field.';
                }
            }
        }
        area(factboxes) { }
    }
    actions
    {
        area(processing)
        {
            action(Offerhistory)
            {
                ApplicationArea = Basic;
                Caption = 'Officer Recruitment History';
                Image = History;
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                RunObject = page "Recruiting Officer History";
                RunPageLink = No = field(No), "Recruitment Center" = field("Recruitment Center"), Corhot = field(Corhot), Type = field(Type);
                ToolTip = 'Executes the Officer Recruitment History action.';
            }
        }
    }
}

