require 'net/sftp'

module Idnow
  class SftpClient
    def initialize(host:, username:, password:, timeout: nil, proxy: nil)
      @host = URI.parse(host).host
      @username = username
      @password = password
      @timeout = timeout
      @proxy = proxy
    end

    def download(file_name)
      data = nil
      options = { password: @password }
      options[:timeout] = @timeout if @timeout
      options[:proxy] = @proxy if @proxy
      Net::SFTP.start(@host, @username, options) do |sftp|
        begin
          data = sftp.download!(file_name)
        rescue Net::SFTP::Exception => e
          raise Idnow::ConnectionException, e
        rescue RuntimeError => e
          raise Idnow::Exception, e
        end
      end
      data
    end
  end
end
