namespace ABH_UAT.ABH_UAT;

page 51531 "Trainer Evaluation Card"
{
    ApplicationArea = All;
    Caption = 'Trainer Evaluation Card';
    PageType = Card;
    SourceTable = "Trainer Evaluation Header";
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Evaluation Code"; Rec."Evaluation Code")
                {
                    ToolTip = 'Specifies the value of the Evaluation Code field.', Comment = '%';
                }
                field("Employee Code"; Rec."Employee Code")
                {
                    ToolTip = 'Specifies the value of the Employee Code field.', Comment = '%';
                }
                field("Employee name"; Rec."Employee name")
                {
                    ToolTip = 'Specifies the value of the Employee name field.', Comment = '%';
                }
                field("Manager Id"; Rec."Manager Id")
                {
                    ToolTip = 'Specifies the value of the Manager Id field.', Comment = '%';
                }
                field("Manager Name"; Rec."Manager Name")
                {
                    ToolTip = 'Specifies the value of the Manager Name field.', Comment = '%';
                }
                field("Course Code"; Rec."Course Code")
                {
                    ToolTip = 'Specifies the value of the Course Code field.', Comment = '%';
                }
                field("Course Name"; Rec."Course Name")
                {
                    ToolTip = 'Specifies the value of the Course Name field.', Comment = '%';
                }
                field(Trainer; Rec.Trainer)
                {
                    ToolTip = 'Specifies the value of the Trainer field.', Comment = '%';
                }
                field("Trainer Name"; Rec."Trainer Name")
                {
                    ToolTip = 'Specifies the value of the Trainer Name field.', Comment = '%';
                }
                field("Training Need"; Rec."Training Need")
                {
                    ToolTip = 'Specifies the value of the Training Need field.', Comment = '%';
                }
                field("Average Score";"Average Score"){}
                field("Created By"; Rec."Created By")
                {
                    ToolTip = 'Specifies the value of the Created By field.', Comment = '%';
                }
                field("Date Created"; Rec."Date Created")
                {
                    ToolTip = 'Specifies the value of the Date Created field.', Comment = '%';
                }
            }
            part(evaluationlines;"Trainer Evaluation line")
            {
                SubPageLink="Employee Code"=field("Employee Code"),"Provider Code"=field(Trainer),"Course code"=field("Course Code"),"Training Need"=field("Training Need");
            }
        }
        
    }
    actions
    {
        area(Processing)
        {
            action(Evaluate)
            {
                Caption='Evaluate';
                ApplicationArea=basic;
                Image=ImplementRegAbsence;
                trigger OnAction()
                begin
                    TestField("Employee Code");
                    TestField(Trainer);
                    TestField("Course Code");
                    TestField("Training Need");
                 evaluationlines.Reset();
                 evaluationlines.SetRange(evaluationlines."Course code","Course Code");
                 evaluationlines.SetRange(evaluationlines."Employee Code","Employee Code");
                 evaluationlines.SetRange(evaluationlines."Provider Code",Trainer);
                 evaluationlines.SetRange("Training Need","Training Need");
                 if evaluationlines.Find('-') then begin
                    repeat

                    until evaluationlines.Next=0;

                 end else if not evaluationlines.Find() then begin
                 evaluationchecklist.Reset();
                 evaluationchecklist.SetRange(evaluationchecklist."Active?",true);
                 if evaluationchecklist.Find('-') then begin
                    repeat
                    evaluationlines.init;
                    evaluationlines."Employee Code":="Employee Code";
                    evaluationlines."Course code":="Course Code";
                    evaluationlines."Training Need":="Training Need";
                    evaluationlines."Provider Code":=Trainer;
                    evaluationlines."Rate Code":=evaluationchecklist.Code;
                    evaluationlines."Rate Factor":=evaluationchecklist."Rating Factor";                    

                    evaluationlines.Insert;


                    until evaluationchecklist.next=0;
                    Message('Rating Criteria added, please rate each line');
                 end;

                 end;

                end;
            }
        }
    }
    var 

    evaluationchecklist:Record "Trainer Evaluation Factors";
    evaluationlines: Record "Trainer Evaluation Lines";
    
}

