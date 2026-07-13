Page 50705 "Food Supplies Setup Card"
{
    PageType = Card;
    SourceTable = "Food Supplies Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(PreparedBy; Rec."Prepared By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Prepared By field.';
                }
                field(ApprovedBy; Rec."Approved By")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Approved By field.';
                }
                field(ReviewStatus; Rec."Review Status")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review Status field.';
                }
                field(RecordNo; Rec."Record No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Record No field.';
                }
                field(ReviewDate; Rec."Review Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Review Date field.';
                }
                field(NextReviewDate; Rec."Next Review Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Next Review Date field.';
                }
                field(Period; Rec.Period)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Period field.';
                }
            }
        }
    }

    actions { }
}

