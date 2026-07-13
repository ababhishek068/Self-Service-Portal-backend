page 51094 "Hr Advertised Job Card"
{
    PageType = Card;
    SourceTable = "HR Employee Requisitions";
    SourceTableView = WHERE(Advertised = FILTER(true));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Job ID"; Rec."Job ID")
                {
                    ToolTip = 'Specifies the value of the Job ID field.';
                }
                field("Requisition Date"; Rec."Requisition Date")
                {
                    ToolTip = 'Specifies the value of the Requisition Date field.';
                }
                field(Positions; Rec.Positions)
                {
                    ToolTip = 'Specifies the value of the Positions field.';
                }
                field("Job Description"; Rec."Job Description")
                {
                    ToolTip = 'Specifies the value of the Job Description field.';
                }
                field("Closing Date"; Rec."Closing Date")
                {
                    ToolTip = 'Specifies the value of the Closing Date field.';
                }
                field("Requisition Type"; Rec."Requisition Type")
                {
                    ToolTip = 'Specifies the value of the Requisition Type field.';
                }
                field("Required Positions"; Rec."Required Positions")
                {
                    ToolTip = 'Specifies the value of the Required Positions field.';
                }
                field("Vacant Positions"; Rec."Vacant Positions")
                {
                    ToolTip = 'Specifies the value of the Vacant Positions field.';
                }
                field("Job Grade"; Rec."Job Grade")
                {
                    ToolTip = 'Specifies the value of the Job Grade field.';
                }
                field("Type of Contract Required"; Rec."Type of Contract Required")
                {
                    ToolTip = 'Specifies the value of the Type of Contract Required field.';
                }
                field("Reason For Request"; Rec."Reason For Request")
                {
                    ToolTip = 'Specifies the value of the Reason For Request field.';
                }
                field("Requisition No."; Rec."Requisition No.")
                {
                    ToolTip = 'Specifies the value of the Requisition No. field.';
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                }
                field("Job Ref No"; Rec."Job Ref No")
                {
                    ToolTip = 'Specifies the value of the Job Ref No field.';
                }
                field(Advertised; Rec.Advertised)
                {
                    ToolTip = 'Specifies the value of the Advertised field.';
                }
                field("Opening Date"; Rec."Opening Date")
                {
                    ToolTip = 'Specifies the value of the Opening Date field.';
                }
            }
        
        }
    }

    actions { 
        
        area(Processing)
        {
            action("Interview Commitee")
            {
                Caption = 'Interview Committee';
                Image = Group;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "Interview Committee";
                RunPageLink = "Job No"=field("Job ID");
                ToolTip = 'Executes the Interview Committee action.';

            }
        }
    }
}

