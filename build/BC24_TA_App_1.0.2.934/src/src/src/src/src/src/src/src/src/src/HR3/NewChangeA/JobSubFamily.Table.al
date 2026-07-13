table 50923 "Job Sub Family"
{
    Caption = 'Job Sub Family';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Job Family Code"; Code[20])
        {
            Caption = 'Job Family Code';
            DataClassification = CustomerContent;
            TableRelation="Job Family";
           trigger OnValidate() begin
            jobfam.Reset();;
            jobfam.SetRange(jobfam."Job Family Code","Job Family Code");
            if jobfam.FindFirst() then begin
                "Job Family Description":=jobfam."Job Family Description";
            end;
           end;
           
        }
        field(2; "Job Family Description"; Text[50])
        {
            Caption = 'Job Family Description';
            DataClassification = CustomerContent;
            Editable=false;
        }
        field(3; "Job Family Sub-Family"; Code[20])
        {
            Caption = 'Job Family Sub-Family';
            DataClassification = CustomerContent;
        }
        field(4; "Job Family Sub-Family Desc"; Text[50])
        {
            Caption = 'Job Family Sub-Family Description';
            DataClassification = CustomerContent;
        }
    }
       
        
    keys
    {        key(PK; "Job Family Code","Job Family Sub-Family")
        {
            Clustered = true;
        }
    }
    
     var
        jobfam: Record "Job Family";
          
}
