Page 51087 "Individual Workplan Card"
{
    PageType = Card;
    SourceTable = "Individual Work Plan";
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
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
                field("Appraisee Comments"; Rec."Appraisee Comments")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Appraisee Comments field.';
                }
                field("Supervisor Comments"; Rec."Supervisor Comments")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                    ToolTip = 'Specifies the value of the Supervisor Comments field.';
                }
            }

            group(Objective)
            {
                part("Individual Workplan Objective"; "Individual Workplan Objective")
                {
                    Editable = false;
                    SubPageLink = Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period");
                }
            }
            group(Targets)
            {
                part("Individual Workplan Target"; "Individual Workplan Target")
                {
                    Editable = false;
                    SubPageLink = Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period");
                }
            }
            group(Activities)
            {
                part("Individual Workplan Activities"; "Individual Workplan Activities")
                {
                    Editable = false;
                    SubPageLink = Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period");
                }
            }
        }
    }
    actions
    {
        area(creation)
        {

            action(Populate)
            {
                ApplicationArea = Basic;
                Caption = 'Populate Objectives';
                Image = AllLines;
                Promoted = true;
                trigger OnAction()
                begin
                    IndividualObj.Reset();
                    IndividualObj.SetRange("Staff No", "Staff No");
                    IndividualObj.SetRange(IndividualObj.Code, Code);
                    IndividualObj.SetRange(IndividualObj."Appraisal Period", "Appraisal Period");
                    if IndividualObj.Find('-') then begin
                        IndividualObj.DeleteAll();
                    end;
                    Departmentobj.Reset();
                    Departmentobj.SetRange(Departmentobj."Appraisal Period", "Appraisal Period");
                    Departmentobj.SetRange(Departmentobj."Department Code", "Global Dimension 1");
                    if Departmentobj.Find('-') then begin
                        repeat
                            IndividualObj.Init();
                            IndividualObj."Staff No" := "Staff No";
                            IndividualObj."Appraisal Period" := "Appraisal Period";
                            //IndividualObj.Code := Code;
                            IndividualObj.Objective := Departmentobj."Objective Description";
                            IndividualObj."Department Code" := "Global Dimension 1";
                            IndividualObj."Departmental Objective Code" := Departmentobj."Objective Code";
                            IndividualObj."Entry No" := IndividualObj."Entry No" + 1;
                            IndividualObj.Insert(true);
                        until Departmentobj.Next = 0;
                    end;


                end;


            }
            action(Obj)
            {
                ApplicationArea = Basic;
                Caption = 'Objectives';
                Image = Dimensions;
                Promoted = true;
                RunObject = Page "Individual Workplan Objective";
                RunPageLink = Code = field(Code), "Staff No" = field("Staff No"), "Appraisal Period" = field("Appraisal Period");
                ToolTip = 'Executes the Objectives action.';
            }
        }
    }
    var
        Departmentobj: record "HR Appraisal Dept. Obj. Setup";
        IndividualObj: Record "Individual Work Plan Objective";
}

