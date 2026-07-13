table 50973 "Item Subcategory"
{
    Caption = 'Item Subcategory';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Item Category"; Code[50])
        {
            Caption = 'Item Category';
            TableRelation="Item Category".code;
        }
        field(2; "Item Sub Category"; Code[50])
        {
            Caption = 'Item Sub Category';
        }
        field(3; "Sub Category Name"; Text[100])
        {
            Caption = 'Sub Category Name';
        }
        field(4;"Number sequence";Code[20])
        {            
            Caption = 'Number sequence';
            TableRelation = "No. Series";        
        }
    }
    keys
    {
        key(PK; "Item Category","Item Sub Category")
        {
            Clustered = true;
        }
    }
}
