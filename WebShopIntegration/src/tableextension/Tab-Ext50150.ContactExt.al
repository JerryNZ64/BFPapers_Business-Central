tableextension 50150 "ContactExt" extends Contact
{
    fields
    {
        field(50000; Password; Text[50])
        {
            Caption = 'Password';
            Enabled = true;
            Editable = true;
            DataClassification = ToBeClassified;
        }
    }
}
