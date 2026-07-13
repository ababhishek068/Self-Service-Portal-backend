Page 51086 "Individual Workplan"
{
    CardPageId = "Individual Workplan Card";
    PageType = List;
    SourceTable = "Individual Work Plan";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Code; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field("Staff No"; Rec."Staff No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Staff No field.';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Employee Name field.';
                }
                field("Appraisal Period"; Rec."Appraisal Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Appraisal Period field.';
                }
                field("Global Dimension 1"; Rec."Global Dimension 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 field.';
                }
                field(Dim1; Rec.Dim1)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim1 field.';
                }
                field("Global Dimension 2"; Rec."Global Dimension 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 field.';
                }
                field(Dim2; Rec.Dim2)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Dim2 field.';
                }
                field("Open To"; Rec."Open To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Open To field.';
                }
            }
        }
    }
}

