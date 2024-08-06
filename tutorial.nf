params.str = 'Hello world!'

process splitLetters {
    output:
    path 'chunk_*'

    """
    printf '${params.str}' | split -b 6 - chunk_
    """
}

process convertToUpper {
    input:
    path x

    output:
    stdout

    """
    cat $x | tr '[a-z]' '[A-Z]'
    """
}

process testS3AccessPython {
    output:
    stdout

    """
    #!/opt/python/3.10.13/bin/python3

    import boto3
    
    def listBuckets():
        s3_client = boto3.client('s3')
        response = s3_client.list_buckets()
        print('These are buckets accessible by your credentials:')
        for bucket in response['Buckets']:
            print(bucket)
    """
}

process printTest {
    input:
    path x

    output:
    stdout

    """
    #!/opt/conda/bin/python3.12

    file = open('$x', "r")
    print(file.readline([0]))
    """
}

process testS3AccessGroovy {
    output:
    stdout

    """
    #!/opt/conda/bin/python3.12

    import boto3
    import subprocess

    def test ():
        s3Client = boto3.client('s3')
        response = s3Client.list_buckets()
        print("These are buckets")
        for bucket in response['Buckets']:
            print(f' {bucket["Name"]}')

    def downloadTest(bucketName, path, title=None):
        s3Client = boto3.client('s3')
        s3Client.download_file(bucketName, path, title)
        return title

    test()
    downloadTest("nextflow-poc", "HelloWorld.txt", title="test.txt")

    """
}

workflow {
    splitLetters | flatten | convertToUpper | view { it.trim() }
    testS3AccessGroovy | view { it.trim()}
}



    


    //  #!/home/linuxbrew/.linuxbrew/opt/groovy/libexec/bin/groovy
    // filepath = file('s3://nextflow-poc/HelloWorld.txt')
    // println(filepath.text)